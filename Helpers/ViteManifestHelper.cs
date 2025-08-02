using System.Text.Json;

namespace HubFootball.Helpers;

public static class ViteManifestHelper
{
    private static readonly string ManifestPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/js/manifest.json");
    private static Dictionary<string, string>? _cache;

    public static string GetAsset(string entry)
    {
        if (_cache == null)
        {
            var json = File.ReadAllText(ManifestPath);
            using var doc = JsonDocument.Parse(json);
            _cache = new Dictionary<string, string>();
            foreach (var element in doc.RootElement.EnumerateObject())
            {
                var file = element.Value.GetProperty("file").GetString()!;
                _cache[element.Name] = file;
            }
        }

        return "/js/" + _cache[entry];
    }
}