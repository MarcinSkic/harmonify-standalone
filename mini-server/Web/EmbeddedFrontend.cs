using System.Reflection;
using Microsoft.Extensions.FileProviders;

namespace Harmonify.MiniServer.Web;

public static class EmbeddedFrontend
{
  public static WebApplication UseEmbeddedFrontend(this WebApplication app)
  {
    ManifestEmbeddedFileProvider? embeddedProvider = null;
    try
    {
      embeddedProvider = new ManifestEmbeddedFileProvider(Assembly.GetExecutingAssembly(), "wwwroot");
    }
    catch (InvalidOperationException ex)
    {
      if (!app.Environment.IsDevelopment())
      {
        throw;
      }

      app.Logger.LogWarning(
        ex,
        "No embedded frontend manifest found - serving API only. This is expected in development; build the frontend into wwwroot for a self-contained app.");
    }

    if (embeddedProvider is null)
    {
      return app;
    }

    app.UseDefaultFiles(new DefaultFilesOptions { FileProvider = embeddedProvider });
    app.UseStaticFiles(new StaticFileOptions { FileProvider = embeddedProvider });
    app.MapFallbackToFile("index.html", new StaticFileOptions { FileProvider = embeddedProvider });

    return app;
  }
}
