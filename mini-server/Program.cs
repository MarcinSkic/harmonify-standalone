using Harmonify.MiniServer.Web;

var builder = WebApplication.CreateBuilder(args);

// Lowest-precedence source, so an appsettings.json next to the binary can still override the port.
builder.Configuration.Sources.Insert(0, new Microsoft.Extensions.Configuration.Memory.MemoryConfigurationSource
{
  InitialData = new Dictionary<string, string?>
  {
    ["Urls"] = "http://localhost:37450",
  }
});

// Services
builder.Services.AddHttpClient();

// CORS
builder.Services.AddCors(options =>
{
  options.AddDefaultPolicy(policy =>
  {
    policy
      .AllowAnyOrigin()
      .AllowAnyHeader()
      .AllowAnyMethod()
      .WithExposedHeaders("Content-Range", "Accept-Ranges", "Content-Length");
  });
});

var app = builder.Build();

app.UseEmbeddedFrontend();

app.UseCors();

app.MapAppEndpoints();

app.Run();
