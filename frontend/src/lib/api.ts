const API_KEY = (import.meta.env.VITE_GUARDIAN_API_KEY ?? "").trim();
const BASE_URL = (import.meta.env.VITE_API_BASE_URL ?? "/api").toString();

export type ApiRequestConfig = {
  params?: Record<string, unknown>;
  headers?: Record<string, string>;
  timeout?: number;
  data?: unknown;
};

export type ApiResponse<T = unknown> = {
  data: T;
  status: number;
  headers: Headers;
};

export class ApiError extends Error {
  response: {
    status: number;
    data: unknown;
    headers: Headers;
  };

  constructor(message: string, status: number, data: unknown, headers: Headers) {
    super(message);
    this.name = "ApiError";
    this.response = { status, data, headers };
  }
}

function isAbsoluteUrl(input: string): boolean {
  return /^https?:\/\//i.test(input);
}

function withParams(url: string, params?: Record<string, unknown>): string {
  if (!params || !Object.keys(params).length) return url;
  const base = typeof window !== "undefined" ? window.location.origin : "http://localhost";
  const parsed = new URL(url, base);
  Object.entries(params).forEach(([key, value]) => {
    if (value == null) return;
    if (Array.isArray(value)) {
      value.forEach((item) => parsed.searchParams.append(key, String(item)));
      return;
    }
    parsed.searchParams.set(key, String(value));
  });
  return isAbsoluteUrl(url)
    ? parsed.toString()
    : `${parsed.pathname}${parsed.search}${parsed.hash}`;
}

function joinBaseAndPath(path: string): string {
  const base = BASE_URL.replace(/\/+$/, "");
  let nextPath = path;
  if (base.endsWith("/api") && nextPath.startsWith("/api/")) {
    nextPath = nextPath.replace(/^\/api/, "");
  }
  const full = `${base}${nextPath.startsWith("/") ? "" : "/"}${nextPath}`.replace(
    /\/api\/api(?=\/|$)/,
    "/api"
  );
  return full || path;
}

function shouldTreatAsJson(payload: unknown): boolean {
  if (payload == null) return false;
  if (typeof payload === "string") return false;
  if (typeof FormData !== "undefined" && payload instanceof FormData) return false;
  if (typeof Blob !== "undefined" && payload instanceof Blob) return false;
  if (typeof URLSearchParams !== "undefined" && payload instanceof URLSearchParams) return false;
  if (typeof ArrayBuffer !== "undefined" && payload instanceof ArrayBuffer) return false;
  return true;
}

function isFormDataPayload(payload: unknown): payload is FormData {
  return typeof FormData !== "undefined" && payload instanceof FormData;
}

async function parseResponseBody(res: Response): Promise<unknown> {
  const contentType = res.headers.get("content-type") || "";
  if (contentType.includes("application/json")) {
    try {
      return await res.json();
    } catch {
      return null;
    }
  }
  const text = await res.text().catch(() => "");
  if (!text) return null;
  try {
    return JSON.parse(text);
  } catch {
    return text;
  }
}

async function send<T>(
  method: string,
  path: string,
  payload: unknown,
  config?: ApiRequestConfig
): Promise<ApiResponse<T>> {
  const headers: Record<string, string> = { ...(config?.headers || {}) };
  const hasApiKeyHeader = Object.keys(headers).some((k) => k.toLowerCase() === "x-api-key");
  if (API_KEY && !hasApiKeyHeader) {
    headers["X-API-Key"] = API_KEY;
  }

  let body: BodyInit | undefined = undefined;
  if (payload !== undefined && method !== "GET" && method !== "HEAD") {
    if (shouldTreatAsJson(payload)) {
      headers["Content-Type"] = headers["Content-Type"] || "application/json";
      body = JSON.stringify(payload);
    } else {
      if (isFormDataPayload(payload)) {
        // Let the browser set multipart boundary; a manual header breaks uploads.
        Object.keys(headers).forEach((key) => {
          if (key.toLowerCase() === "content-type") {
            delete headers[key];
          }
        });
      }
      body = payload as BodyInit;
    }
  }

  const controller = new AbortController();
  const timeoutMs = Math.max(0, Number(config?.timeout ?? 15000));
  const timer = timeoutMs
    ? setTimeout(() => controller.abort(), timeoutMs)
    : null;

  try {
    const basePath = isAbsoluteUrl(path) ? path : joinBaseAndPath(path);
    const url = withParams(basePath, config?.params);
    const res = await fetch(url, {
      method,
      headers,
      credentials: "include",
      signal: controller.signal,
      body,
    });
    const data = await parseResponseBody(res);
    if (!res.ok) {
      throw new ApiError(
        `${method} ${path} failed: ${res.status}`,
        res.status,
        data,
        res.headers
      );
    }
    return { data: data as T, status: res.status, headers: res.headers };
  } finally {
    if (timer) clearTimeout(timer);
  }
}

export const api = {
  get: <T = unknown>(path: string, config?: ApiRequestConfig) =>
    send<T>("GET", path, undefined, config),
  post: <T = unknown>(path: string, data?: unknown, config?: ApiRequestConfig) =>
    send<T>("POST", path, data, config),
  put: <T = unknown>(path: string, data?: unknown, config?: ApiRequestConfig) =>
    send<T>("PUT", path, data, config),
  patch: <T = unknown>(path: string, data?: unknown, config?: ApiRequestConfig) =>
    send<T>("PATCH", path, data, config),
  delete: <T = unknown>(path: string, config?: ApiRequestConfig) =>
    send<T>("DELETE", path, config?.data, config),
};

export default api;
