namespace Shared.Models;

public class HealthStatus
{
    public string Status { get; set; } = "healthy";
    public string Service { get; set; } = string.Empty;
    public DateTime Timestamp { get; set; } = DateTime.UtcNow;
    public Dictionary<string, object>? Details { get; set; }
}
