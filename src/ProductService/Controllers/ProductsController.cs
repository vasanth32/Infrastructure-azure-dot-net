using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc;

namespace ProductService.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    private static readonly List<Product> _products = new()
    {
        new Product { Id = 1, Name = "Laptop", Price = 999.99m, Description = "High-performance laptop", Stock = 50 },
        new Product { Id = 2, Name = "Mouse", Price = 29.99m, Description = "Wireless mouse", Stock = 200 },
        new Product { Id = 3, Name = "Keyboard", Price = 79.99m, Description = "Mechanical keyboard", Stock = 150 }
    };

    [HttpGet]
    public ActionResult<IEnumerable<Product>> GetProducts()
    {
        return Ok(_products);
    }

    [HttpGet("count")]
    public ActionResult<int> GetProductCount()
    {
        return Ok(_products.Count);
    }

    [HttpGet("{id}")]
    public ActionResult<Product> GetProduct(int id)
    {
        if (id <= 0)
        {
            return BadRequest(new { error = "Invalid product ID. ID must be greater than 0." });
        }

        var product = _products.FirstOrDefault(p => p.Id == id);
        if (product == null)
        {
            return NotFound(new { error = $"Product with ID {id} not found." });
        }
        return Ok(product);
    }

    [HttpPost]
    public ActionResult<Product> CreateProduct([FromBody] CreateProductRequest request)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        // Validate business rules
        if (request.Price < 0)
        {
            return BadRequest(new { error = "Price cannot be negative." });
        }

        if (request.Stock < 0)
        {
            return BadRequest(new { error = "Stock cannot be negative." });
        }

        if (string.IsNullOrWhiteSpace(request.Name))
        {
            return BadRequest(new { error = "Product name is required." });
        }

        var product = new Product
        {
            Id = _products.Count > 0 ? _products.Max(p => p.Id) + 1 : 1,
            Name = request.Name,
            Price = request.Price,
            Description = request.Description ?? string.Empty,
            Stock = request.Stock
        };

        _products.Add(product);
        return CreatedAtAction(nameof(GetProduct), new { id = product.Id }, product);
    }

    [HttpPut("{id}")]
    public IActionResult UpdateProduct(int id, [FromBody] UpdateProductRequest request)
    {
        if (id <= 0)
        {
            return BadRequest(new { error = "Invalid product ID. ID must be greater than 0." });
        }

        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        var existingProduct = _products.FirstOrDefault(p => p.Id == id);
        if (existingProduct == null)
        {
            return NotFound(new { error = $"Product with ID {id} not found." });
        }

        // Validate business rules
        if (request.Price.HasValue && request.Price.Value < 0)
        {
            return BadRequest(new { error = "Price cannot be negative." });
        }

        if (request.Stock.HasValue && request.Stock.Value < 0)
        {
            return BadRequest(new { error = "Stock cannot be negative." });
        }

        // Update only provided fields
        if (!string.IsNullOrWhiteSpace(request.Name))
        {
            existingProduct.Name = request.Name;
        }

        if (request.Price.HasValue)
        {
            existingProduct.Price = request.Price.Value;
        }

        if (request.Description != null)
        {
            existingProduct.Description = request.Description;
        }

        if (request.Stock.HasValue)
        {
            existingProduct.Stock = request.Stock.Value;
        }

        return NoContent();
    }

    [HttpDelete("{id}")]
    public IActionResult DeleteProduct(int id)
    {
        if (id <= 0)
        {
            return BadRequest(new { error = "Invalid product ID. ID must be greater than 0." });
        }

        var product = _products.FirstOrDefault(p => p.Id == id);
        if (product == null)
        {
            return NotFound(new { error = $"Product with ID {id} not found." });
        }

        _products.Remove(product);
        return NoContent();
    }
}

public class Product
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public decimal Price { get; set; }
    public string Description { get; set; } = string.Empty;
    public int Stock { get; set; }
}

public class CreateProductRequest
{
    [Required(ErrorMessage = "Product name is required.")]
    [StringLength(200, MinimumLength = 1, ErrorMessage = "Product name must be between 1 and 200 characters.")]
    public string Name { get; set; } = string.Empty;

    [Required(ErrorMessage = "Price is required.")]
    [Range(0, double.MaxValue, ErrorMessage = "Price must be greater than or equal to 0.")]
    public decimal Price { get; set; }

    [StringLength(1000, ErrorMessage = "Description cannot exceed 1000 characters.")]
    public string? Description { get; set; }

    [Required(ErrorMessage = "Stock is required.")]
    [Range(0, int.MaxValue, ErrorMessage = "Stock must be greater than or equal to 0.")]
    public int Stock { get; set; }
}

public class UpdateProductRequest
{
    [StringLength(200, MinimumLength = 1, ErrorMessage = "Product name must be between 1 and 200 characters.")]
    public string? Name { get; set; }

    [Range(0, double.MaxValue, ErrorMessage = "Price must be greater than or equal to 0.")]
    public decimal? Price { get; set; }

    [StringLength(1000, ErrorMessage = "Description cannot exceed 1000 characters.")]
    public string? Description { get; set; }

    [Range(0, int.MaxValue, ErrorMessage = "Stock must be greater than or equal to 0.")]
    public int? Stock { get; set; }
}
