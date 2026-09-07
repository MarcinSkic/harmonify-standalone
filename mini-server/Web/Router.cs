namespace Harmonify.MiniServer.Web;

public static class Router
{
  public static WebApplication MapAppEndpoints(this WebApplication app)
  {
    // Other half of this contract: the hosted serverless function in
    // harmonify-frontend/api/linkPreview/index.ts. Both must answer identically — same status
    // codes, same `{ error }` bodies, same caching headers — so change them together.
    app.MapGet("/api/linkPreview", async (string? url, HttpResponse response, IHttpClientFactory httpClientFactory) =>
    {
      if (url is null)
        return Results.BadRequest(new { error = "Missing url parameter" });

      if (!Uri.TryCreate(url, UriKind.Absolute, out _))
        return Results.BadRequest(new { error = "Invalid URL" });

      try
      {
        var client = httpClientFactory.CreateClient();
        var upstream = await client.GetAsync(url);
        if (!upstream.IsSuccessStatusCode)
        {
          var status = (int)upstream.StatusCode;
          return Results.Json(new { error = $"Upstream returned {status}" }, statusCode: status);
        }

        var contentType = upstream.Content.Headers.ContentType?.ToString() ?? "application/octet-stream";
        var bytes = await upstream.Content.ReadAsByteArrayAsync();

        response.Headers.CacheControl = "public, max-age=604800, immutable";
        return Results.Bytes(bytes, contentType);
      }
      catch (Exception ex)
      {
        return Results.Json(new { error = ex.Message }, statusCode: 502);
      }
    });

    return app;
  }
}
