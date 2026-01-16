using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc;

namespace NotificationService.Controllers;

[ApiController]
[Route("api/[controller]")]
public class NotificationsController : ControllerBase
{
    private static readonly List<Notification> _notifications = new();
    private readonly ILogger<NotificationsController> _logger;
    private readonly Random _random = new();

    public NotificationsController(ILogger<NotificationsController> logger)
    {
        _logger = logger;
    }

    [HttpGet]
    public ActionResult<IEnumerable<Notification>> GetNotifications()
    {
        return Ok(_notifications);
    }

    [HttpGet("{id}")]
    public ActionResult<Notification> GetNotification(int id)
    {
        if (id <= 0)
        {
            return BadRequest(new { error = "Invalid notification ID. ID must be greater than 0." });
        }

        var notification = _notifications.FirstOrDefault(n => n.Id == id);
        if (notification == null)
        {
            return NotFound(new { error = $"Notification with ID {id} not found." });
        }
        return Ok(notification);
    }

    [HttpPost("send")]
    public async Task<ActionResult<Notification>> SendNotification([FromBody] SendNotificationRequest request)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        // Validate notification type
        var validTypes = new[] { "Email", "SMS" };
        if (!validTypes.Contains(request.Type, StringComparer.OrdinalIgnoreCase))
        {
            return BadRequest(new { error = $"Invalid notification type. Valid types are: {string.Join(", ", validTypes)}" });
        }

        // Validate recipient
        if (string.IsNullOrWhiteSpace(request.Recipient))
        {
            return BadRequest(new { error = "Recipient is required." });
        }

        // Validate message
        if (string.IsNullOrWhiteSpace(request.Message))
        {
            return BadRequest(new { error = "Message is required." });
        }

        var notification = new Notification
        {
            Id = _notifications.Count > 0 ? _notifications.Max(n => n.Id) + 1 : 1,
            Type = request.Type,
            Recipient = request.Recipient,
            Message = request.Message,
            Status = "Pending",
            CreatedAt = DateTime.UtcNow
        };

        _notifications.Add(notification);

        try
        {
            _logger.LogInformation("Sending {Type} notification to {Recipient}. NotificationId={NotificationId}",
                request.Type, request.Recipient, notification.Id);

            // Simulate sending delay based on type
            if (request.Type.Equals("Email", StringComparison.OrdinalIgnoreCase))
            {
                // Simulate email sending with 2-3 second delay
                var delay = _random.Next(2000, 3001); // 2000-3000ms
                await Task.Delay(delay);
                _logger.LogInformation("Email notification sent successfully. NotificationId={NotificationId}, Delay={Delay}ms",
                    notification.Id, delay);
            }
            else if (request.Type.Equals("SMS", StringComparison.OrdinalIgnoreCase))
            {
                // Simulate SMS sending with 1-2 second delay
                var delay = _random.Next(1000, 2001); // 1000-2000ms
                await Task.Delay(delay);
                _logger.LogInformation("SMS notification sent successfully. NotificationId={NotificationId}, Delay={Delay}ms",
                    notification.Id, delay);
            }

            notification.Status = "Sent";
            _logger.LogInformation("Notification sent successfully. NotificationId={NotificationId}, Type={Type}, Recipient={Recipient}",
                notification.Id, notification.Type, notification.Recipient);
        }
        catch (Exception ex)
        {
            notification.Status = "Failed";
            _logger.LogError(ex, "Failed to send notification. NotificationId={NotificationId}, Type={Type}, Recipient={Recipient}",
                notification.Id, notification.Type, notification.Recipient);
            return StatusCode(500, new { error = "Failed to send notification.", notificationId = notification.Id });
        }

        return CreatedAtAction(nameof(GetNotification), new { id = notification.Id }, notification);
    }
}

public class Notification
{
    public int Id { get; set; }
    public string Type { get; set; } = string.Empty; // Email or SMS
    public string Recipient { get; set; } = string.Empty;
    public string Message { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
}

public class SendNotificationRequest
{
    [Required(ErrorMessage = "Notification type is required.")]
    public string Type { get; set; } = string.Empty; // Email or SMS

    [Required(ErrorMessage = "Recipient is required.")]
    public string Recipient { get; set; } = string.Empty; // Email address or phone number

    [Required(ErrorMessage = "Message is required.")]
    [StringLength(1000, MinimumLength = 1, ErrorMessage = "Message must be between 1 and 1000 characters.")]
    public string Message { get; set; } = string.Empty;
}
