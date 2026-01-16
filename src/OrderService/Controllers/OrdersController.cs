using System.ComponentModel.DataAnnotations;
using System.Text.RegularExpressions;
using Microsoft.AspNetCore.Mvc;

namespace OrderService.Controllers;

[ApiController]
[Route("api/[controller]")]
public class OrdersController : ControllerBase
{
    private static readonly List<Order> _orders = new()
    {
        new Order { Id = 1, ProductId = 1, Quantity = 1, CustomerEmail = "customer1@example.com", Status = "Completed", CreatedAt = DateTime.UtcNow.AddDays(-2) },
        new Order { Id = 2, ProductId = 2, Quantity = 2, CustomerEmail = "customer2@example.com", Status = "Processing", CreatedAt = DateTime.UtcNow.AddDays(-1) },
        new Order { Id = 3, ProductId = 3, Quantity = 1, CustomerEmail = "customer1@example.com", Status = "Pending", CreatedAt = DateTime.UtcNow }
    };

    private readonly IHttpClientFactory _httpClientFactory;
    private readonly ILogger<OrdersController> _logger;

    public OrdersController(IHttpClientFactory httpClientFactory, ILogger<OrdersController> logger)
    {
        _httpClientFactory = httpClientFactory;
        _logger = logger;
    }

    [HttpGet]
    public ActionResult<IEnumerable<Order>> GetOrders()
    {
        return Ok(_orders);
    }

    [HttpGet("{id}")]
    public ActionResult<Order> GetOrder(int id)
    {
        if (id <= 0)
        {
            return BadRequest(new { error = "Invalid order ID. ID must be greater than 0." });
        }

        var order = _orders.FirstOrDefault(o => o.Id == id);
        if (order == null)
        {
            return NotFound(new { error = $"Order with ID {id} not found." });
        }
        return Ok(order);
    }

    [HttpPost]
    public async Task<ActionResult<Order>> CreateOrder([FromBody] CreateOrderRequest request)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        // Validate email format
        if (!IsValidEmail(request.CustomerEmail))
        {
            return BadRequest(new { error = "Invalid email format." });
        }

        // Validate quantity
        if (request.Quantity <= 0)
        {
            return BadRequest(new { error = "Quantity must be greater than 0." });
        }

        // Validate product exists
        var productExists = await ValidateProductExistsAsync(request.ProductId);
        if (!productExists)
        {
            return BadRequest(new { error = $"Product with ID {request.ProductId} does not exist." });
        }

        var order = new Order
        {
            Id = _orders.Count > 0 ? _orders.Max(o => o.Id) + 1 : 1,
            ProductId = request.ProductId,
            Quantity = request.Quantity,
            CustomerEmail = request.CustomerEmail,
            Status = "Pending",
            CreatedAt = DateTime.UtcNow
        };

        _orders.Add(order);
        _logger.LogInformation("Order created: OrderId={OrderId}, ProductId={ProductId}, Quantity={Quantity}, CustomerEmail={CustomerEmail}",
            order.Id, order.ProductId, order.Quantity, order.CustomerEmail);

        return CreatedAtAction(nameof(GetOrder), new { id = order.Id }, order);
    }

    [HttpPut("{id}/status")]
    public IActionResult UpdateOrderStatus(int id, [FromBody] UpdateOrderStatusRequest request)
    {
        if (id <= 0)
        {
            return BadRequest(new { error = "Invalid order ID. ID must be greater than 0." });
        }

        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        var existingOrder = _orders.FirstOrDefault(o => o.Id == id);
        if (existingOrder == null)
        {
            return NotFound(new { error = $"Order with ID {id} not found." });
        }

        // Validate status values
        var validStatuses = new[] { "Pending", "Processing", "Completed", "Cancelled" };
        if (!validStatuses.Contains(request.Status, StringComparer.OrdinalIgnoreCase))
        {
            return BadRequest(new { error = $"Invalid status. Valid statuses are: {string.Join(", ", validStatuses)}" });
        }

        existingOrder.Status = request.Status;
        _logger.LogInformation("Order status updated: OrderId={OrderId}, NewStatus={Status}", id, request.Status);

        return NoContent();
    }

    private Task<bool> ValidateProductExistsAsync(int productId)
    {
        try
        {
            // For now, we'll use a simple mock validation
            // In a real scenario, this would call ProductService via HTTP
            // For demonstration, we'll check against known product IDs (1, 2, 3)
            // This can be replaced with actual HTTP call to ProductService later
            
            // In production, this would be: var baseUrl = _configuration["ProductService:BaseUrl"];
            // For now, we'll use a mock check
            var knownProductIds = new[] { 1, 2, 3 };
            var exists = knownProductIds.Contains(productId);

            // Future implementation:
            // var client = _httpClientFactory.CreateClient();
            // var response = await client.GetAsync($"{baseUrl}/api/products/{productId}");
            // return response.IsSuccessStatusCode;
            
            return Task.FromResult(exists);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error validating product existence for ProductId={ProductId}", productId);
            // In case of error, we'll allow the order to be created (fail open)
            // In production, you might want to fail closed depending on your requirements
            return Task.FromResult(true);
        }
    }

    private static bool IsValidEmail(string email)
    {
        if (string.IsNullOrWhiteSpace(email))
            return false;

        try
        {
            var emailRegex = new Regex(@"^[^@\s]+@[^@\s]+\.[^@\s]+$", RegexOptions.IgnoreCase);
            return emailRegex.IsMatch(email);
        }
        catch
        {
            return false;
        }
    }
}

public class Order
{
    public int Id { get; set; }
    public int ProductId { get; set; }
    public int Quantity { get; set; }
    public string CustomerEmail { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
}

public class CreateOrderRequest
{
    [Required(ErrorMessage = "Product ID is required.")]
    [Range(1, int.MaxValue, ErrorMessage = "Product ID must be greater than 0.")]
    public int ProductId { get; set; }

    [Required(ErrorMessage = "Quantity is required.")]
    [Range(1, int.MaxValue, ErrorMessage = "Quantity must be greater than 0.")]
    public int Quantity { get; set; }

    [Required(ErrorMessage = "Customer email is required.")]
    [EmailAddress(ErrorMessage = "Invalid email format.")]
    public string CustomerEmail { get; set; } = string.Empty;
}

public class UpdateOrderStatusRequest
{
    [Required(ErrorMessage = "Status is required.")]
    public string Status { get; set; } = string.Empty;
}
