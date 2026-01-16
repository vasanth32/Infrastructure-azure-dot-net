# Infrastructure Azure .NET - Progress Tracker

## Overview
This document tracks the progress of building a microservices infrastructure using .NET 8 and Azure.

---

## Task 1: Create Solution Structure ✅

### Status: Completed

### What Was Done:
1. Created a .NET solution (`InfrastructureAzureDotNet.sln`) with 4 projects:
   - **ProductService** - Web API for product CRUD operations
   - **OrderService** - Web API for order management
   - **NotificationService** - Web API for notifications (email/SMS mock)
   - **Shared** - Class library for shared models

2. **Project Structure:**
   ```
   Infrastructure-azure-dot-net/
   ├── InfrastructureAzureDotNet.sln
   └── src/
       ├── ProductService/
       │   ├── Controllers/
       │   │   ├── ProductsController.cs
       │   │   └── HealthController.cs
       │   ├── Program.cs
       │   └── appsettings.json
       ├── OrderService/
       │   ├── Controllers/
       │   │   ├── OrdersController.cs
       │   │   └── HealthController.cs
       │   ├── Program.cs
       │   └── appsettings.json
       ├── NotificationService/
       │   ├── Controllers/
       │   │   ├── NotificationsController.cs
       │   │   └── HealthController.cs
       │   ├── Program.cs
       │   └── appsettings.json
       └── Shared/
           └── Models/
               ├── ApiResponse.cs
               └── HealthStatus.cs
   ```

3. **Features Implemented:**
   - ✅ All services use .NET 8
   - ✅ Swagger/OpenAPI enabled for all services
   - ✅ `/health` endpoint returns 200 OK (using ASP.NET Core Health Checks)
   - ✅ `appsettings.json` configuration files for each service
   - ✅ Controllers-based architecture (not minimal APIs)
   - ✅ Basic CRUD operations for each service

### Service Details:

#### ProductService
- **Endpoints:**
  - `GET /api/products` - Get all products
  - `GET /api/products/{id}` - Get product by ID
  - `POST /api/products` - Create new product
  - `PUT /api/products/{id}` - Update product
  - `DELETE /api/products/{id}` - Delete product
  - `GET /health` - Health check endpoint

#### OrderService
- **Endpoints:**
  - `GET /api/orders` - Get all orders
  - `GET /api/orders/{id}` - Get order by ID
  - `POST /api/orders` - Create new order
  - `PUT /api/orders/{id}` - Update order
  - `DELETE /api/orders/{id}` - Delete order
  - `GET /health` - Health check endpoint

#### NotificationService
- **Endpoints:**
  - `GET /api/notifications` - Get all notifications
  - `GET /api/notifications/{id}` - Get notification by ID
  - `POST /api/notifications/email` - Send email notification (mock)
  - `POST /api/notifications/sms` - Send SMS notification (mock)
  - `DELETE /api/notifications/{id}` - Delete notification
  - `GET /health` - Health check endpoint

---

## Important Interview Questions & Answers

### 1. What is a Microservices Architecture?

**Answer:**
Microservices architecture is an approach to building applications as a collection of small, independent services that:
- Are loosely coupled and can be developed, deployed, and scaled independently
- Communicate over well-defined APIs (usually HTTP/REST or messaging)
- Each service owns its own data and business logic
- Can be written in different programming languages/frameworks
- Have their own databases (Database per Service pattern)

**Benefits:**
- Independent deployment and scaling
- Technology diversity
- Fault isolation
- Team autonomy

**Challenges:**
- Distributed system complexity
- Data consistency
- Network latency
- Service discovery and communication

---

### 2. What is the difference between Controllers and Minimal APIs in ASP.NET Core?

**Answer:**

**Controllers (Traditional Approach):**
- Use class-based controllers with attributes
- Better for complex applications with many endpoints
- Supports dependency injection via constructor
- Better organization for large APIs
- Example:
```csharp
[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    [HttpGet]
    public IActionResult Get() { }
}
```

**Minimal APIs:**
- Introduced in .NET 6
- Use lambda expressions and route handlers
- Less boilerplate code
- Better for simple APIs or microservices with few endpoints
- Example:
```csharp
app.MapGet("/products", () => { });
```

**When to use Controllers:**
- Large applications
- Need complex routing
- Team familiarity with MVC pattern
- Need advanced features (filters, model binding, etc.)

**When to use Minimal APIs:**
- Simple microservices
- Prototyping
- Small APIs
- Performance-critical scenarios

---

### 3. What is Swagger/OpenAPI and why is it important?

**Answer:**
Swagger (now OpenAPI) is a specification for describing RESTful APIs. In ASP.NET Core, it's implemented via Swashbuckle.

**Benefits:**
- **API Documentation:** Auto-generated interactive documentation
- **Testing:** Test APIs directly from the browser
- **Client Generation:** Generate client SDKs automatically
- **Contract Definition:** Serves as a contract between frontend and backend teams
- **Versioning:** Helps manage API versions

**How it works in .NET:**
```csharp
builder.Services.AddSwaggerGen();
// In pipeline:
app.UseSwagger();
app.UseSwaggerUI();
```

**Access:** `https://localhost:port/swagger`

---

### 4. What are Health Checks in ASP.NET Core?

**Answer:**
Health checks are endpoints that report the health status of an application and its dependencies.

**Types:**
1. **Basic Health Check:** Simple endpoint returning healthy/unhealthy
2. **Dependency Health Checks:** Check database, external APIs, etc.
3. **Liveness Probe:** Indicates if the app is running
4. **Readiness Probe:** Indicates if the app is ready to accept traffic

**Implementation:**
```csharp
builder.Services.AddHealthChecks();
app.MapHealthChecks("/health");
```

**Use Cases:**
- Kubernetes liveness/readiness probes
- Load balancer health monitoring
- Application monitoring tools
- Container orchestration

**Advanced Example:**
```csharp
builder.Services.AddHealthChecks()
    .AddCheck<DatabaseHealthCheck>("database")
    .AddCheck<ExternalApiHealthCheck>("external-api");
```

---

### 5. What is appsettings.json and how does configuration work in ASP.NET Core?

**Answer:**
`appsettings.json` is the default configuration file in ASP.NET Core applications.

**Features:**
- JSON-based configuration
- Environment-specific files (`appsettings.Development.json`)
- Hierarchical configuration
- Can be overridden by environment variables
- Supports multiple sources (JSON, XML, INI, environment variables, command-line arguments)

**Accessing Configuration:**
```csharp
// In Program.cs
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
var apiKey = builder.Configuration["ApiSettings:ApiKey"];

// Via IConfiguration injection
public class MyService
{
    private readonly IConfiguration _configuration;
    public MyService(IConfiguration configuration)
    {
        _configuration = configuration;
    }
}
```

**Best Practices:**
- Never commit secrets to appsettings.json
- Use User Secrets for development
- Use Azure Key Vault for production
- Use environment variables for sensitive data

---

### 6. What is the Shared Class Library pattern in Microservices?

**Answer:**
A shared class library contains common code that multiple microservices can reference.

**What to Share:**
- ✅ Common DTOs/Models
- ✅ Shared utilities
- ✅ Common interfaces
- ✅ Validation logic
- ✅ Constants

**What NOT to Share:**
- ❌ Business logic
- ❌ Database contexts
- ❌ Service implementations
- ❌ Heavy dependencies

**Benefits:**
- Code reuse
- Consistency across services
- Single source of truth for shared models

**Challenges:**
- Tight coupling risk
- Version management
- Deployment coordination

**Best Practice:**
- Keep shared libraries minimal
- Use semantic versioning
- Consider API contracts instead of shared libraries

---

### 7. What is the difference between .NET Framework and .NET (Core)?

**Answer:**

| Feature | .NET Framework | .NET (Core/5+) |
|---------|---------------|----------------|
| Platform | Windows only | Cross-platform |
| Open Source | No | Yes |
| Performance | Slower | Faster |
| Deployment | Framework-dependent | Self-contained or framework-dependent |
| Versioning | 4.x | 5, 6, 7, 8+ |
| Microservices | Not ideal | Excellent support |

**.NET 8 Features:**
- Latest LTS version
- Improved performance
- Native AOT
- Minimal APIs
- Enhanced container support

---

### 8. How do you structure a .NET Solution for Microservices?

**Answer:**

**Option 1: Monorepo (Single Solution)**
```
Solution.sln
├── src/
│   ├── Service1/
│   ├── Service2/
│   └── Shared/
└── tests/
```

**Option 2: Separate Repositories**
- Each service in its own repository
- Shared library as NuGet package

**Best Practices:**
- Separate projects for each service
- Shared library for common code
- Test projects for each service
- Clear separation of concerns
- Independent deployment capability

---

---

### 9. How do you implement Validation in ASP.NET Core?

**Answer:**

**Data Annotations:**
```csharp
public class CreateProductRequest
{
    [Required(ErrorMessage = "Name is required.")]
    [StringLength(200, MinimumLength = 1)]
    public string Name { get; set; }
    
    [Range(0, double.MaxValue)]
    public decimal Price { get; set; }
}
```

**Model State Validation:**
```csharp
if (!ModelState.IsValid)
{
    return BadRequest(ModelState);
}
```

**Custom Validation:**
- Implement `IValidatableObject`
- Create custom validation attributes
- Use FluentValidation library

**Best Practices:**
- Validate at the API boundary
- Return clear error messages
- Use appropriate HTTP status codes (400 for validation errors)
- Separate request DTOs from domain models

---

### 10. How do you handle Errors in ASP.NET Core APIs?

**Answer:**

**HTTP Status Codes:**
- `200 OK` - Success
- `201 Created` - Resource created
- `400 Bad Request` - Validation errors
- `404 Not Found` - Resource not found
- `500 Internal Server Error` - Server errors

**Error Response Format:**
```csharp
return BadRequest(new { error = "Invalid product ID." });
return NotFound(new { error = $"Product with ID {id} not found." });
```

**Global Exception Handling:**
```csharp
app.UseExceptionHandler(errorApp =>
{
    errorApp.Run(async context =>
    {
        // Handle exceptions globally
    });
});
```

**Best Practices:**
- Consistent error response format
- Don't expose internal details in production
- Log errors for debugging
- Use Problem Details (RFC 7807) for standard error format

---

### 11. What is IHttpClientFactory and why use it?

**Answer:**

`IHttpClientFactory` is a factory for creating `HttpClient` instances in ASP.NET Core.

**Problems it solves:**
- **Socket Exhaustion:** Reusing HttpClient instances prevents port exhaustion
- **DNS Updates:** Handles DNS changes automatically
- **Lifecycle Management:** Properly manages HttpClient lifecycle
- **Configuration:** Centralized HTTP client configuration

**Usage:**
```csharp
// Register in Program.cs
builder.Services.AddHttpClient();

// Inject and use
public class MyService
{
    private readonly IHttpClientFactory _httpClientFactory;
    
    public async Task CallApi()
    {
        var client = _httpClientFactory.CreateClient();
        var response = await client.GetAsync("https://api.example.com");
    }
}
```

**Named Clients:**
```csharp
builder.Services.AddHttpClient("ProductService", client =>
{
    client.BaseAddress = new Uri("https://productservice.com");
});

var client = _httpClientFactory.CreateClient("ProductService");
```

---

### 12. What is ILogger and how do you use it?

**Answer:**

`ILogger` is the logging abstraction in ASP.NET Core.

**Log Levels:**
- `Trace` - Very detailed logs
- `Debug` - Debugging information
- `Information` - General information
- `Warning` - Warning messages
- `Error` - Error messages
- `Critical` - Critical failures

**Usage:**
```csharp
public class MyController : ControllerBase
{
    private readonly ILogger<MyController> _logger;
    
    public MyController(ILogger<MyController> logger)
    {
        _logger = logger;
    }
    
    public IActionResult Get()
    {
        _logger.LogInformation("Getting products");
        _logger.LogError("Error occurred: {Error}", ex.Message);
    }
}
```

**Structured Logging:**
```csharp
_logger.LogInformation(
    "Order created: OrderId={OrderId}, ProductId={ProductId}",
    order.Id, order.ProductId);
```

**Best Practices:**
- Use appropriate log levels
- Include context in log messages
- Use structured logging for better querying
- Don't log sensitive information
- Use scoped logging in production

---

### 13. How do you implement Async/Await in ASP.NET Core?

**Answer:**

**Async Controllers:**
```csharp
[HttpPost]
public async Task<ActionResult<Order>> CreateOrder([FromBody] CreateOrderRequest request)
{
    var result = await SomeAsyncOperation();
    return Ok(result);
}
```

**Benefits:**
- Non-blocking I/O operations
- Better scalability
- Prevents thread pool starvation

**Best Practices:**
- Use `async Task` for async methods
- Always await async operations
- Don't use `Task.Result` or `.Wait()` (causes deadlocks)
- Use `ConfigureAwait(false)` in library code
- Return `Task` or `Task<T>` from async methods

**Common Mistakes:**
- `async void` (only for event handlers)
- Not awaiting async calls
- Blocking async code with `.Result` or `.Wait()`

---

## Task 2: ProductService Implementation ✅

### Status: Completed

### What Was Done:
1. **Product Model Updated:**
   - Added `Stock` field (int)
   - Fields: Id, Name, Price, Description, Stock

2. **CRUD Endpoints:**
   - `GET /api/products` - List all products
   - `GET /api/products/{id}` - Get product by ID
   - `POST /api/products` - Create product
   - `PUT /api/products/{id}` - Update product
   - `DELETE /api/products/{id}` - Delete product

3. **Error Handling & Validation:**
   - Input validation using Data Annotations
   - Business rule validation (price/stock cannot be negative)
   - Proper HTTP status codes (400 Bad Request, 404 Not Found)
   - Detailed error messages in responses
   - Model state validation

4. **Request/Response Models:**
   - `CreateProductRequest` with validation attributes
   - `UpdateProductRequest` for partial updates
   - Proper error response format

---

## Task 3: OrderService Implementation ✅

### Status: Completed

### What Was Done:
1. **Order Model Updated:**
   - Changed to: Id, ProductId, Quantity, CustomerEmail, Status, CreatedAt
   - Removed: CustomerId, OrderDate, TotalAmount

2. **CRUD Endpoints:**
   - `GET /api/orders` - List all orders
   - `GET /api/orders/{id}` - Get order by ID
   - `POST /api/orders` - Create order (with product validation)
   - `PUT /api/orders/{id}/status` - Update order status only

3. **Product Validation:**
   - Validates product exists before creating order
   - Mock implementation (checks against known product IDs: 1, 2, 3)
   - Ready for HTTP client integration with ProductService
   - Uses IHttpClientFactory for future service-to-service calls

4. **Error Handling:**
   - Email format validation
   - Quantity validation (must be > 0)
   - Status validation (Pending, Processing, Completed, Cancelled)
   - Proper error messages and HTTP status codes
   - Logging for order creation and status updates

---

## Task 4: NotificationService Implementation ✅

### Status: Completed

### What Was Done:
1. **Notification Model Updated:**
   - Fields: Id, Type, Recipient, Message, Status, CreatedAt
   - Removed: Subject, SentAt

2. **Endpoints:**
   - `GET /api/notifications` - List all notifications
   - `GET /api/notifications/{id}` - Get notification by ID
   - `POST /api/notifications/send` - Send notification (unified endpoint)

3. **Mock Implementation with Delays:**
   - Email: 2-3 second delay (randomized)
   - SMS: 1-2 second delay (randomized)
   - Simulates real-world notification sending

4. **Logging:**
   - Uses ILogger instead of Console.WriteLine
   - Logs notification attempts, successes, and failures
   - Structured logging with notification details
   - Error logging for failed notifications

5. **Error Handling:**
   - Type validation (Email or SMS)
   - Recipient and message validation
   - Status tracking (Pending → Sent/Failed)
   - Proper error responses

---

## Task 5: Health Endpoints ✅

### Status: Completed

### What Was Done:
1. **Health Check Implementation:**
   - Uses `Microsoft.Extensions.Diagnostics.HealthChecks`
   - Custom response format: `{"status": "healthy", "service": "ServiceName"}`
   - Endpoint: `GET /health` on all services

2. **Configuration:**
   - Registered in `Program.cs` for each service
   - Custom `ResponseWriter` to format output
   - Returns 200 OK when healthy

3. **Services:**
   - ProductService: `/health` → `{"status": "healthy", "service": "ProductService"}`
   - OrderService: `/health` → `{"status": "healthy", "service": "OrderService"}`
   - NotificationService: `/health` → `{"status": "healthy", "service": "NotificationService"}`

---

## Next Steps (Future Tasks)

- [ ] Add database integration (Entity Framework Core)
- [ ] Implement actual service-to-service communication (HTTP client calls)
- [ ] Add authentication and authorization
- [ ] Implement API Gateway
- [ ] Add Docker support
- [ ] Add logging and monitoring
- [ ] Implement message queuing (Azure Service Bus)
- [ ] Add unit and integration tests
- [ ] Configure CI/CD pipelines
- [ ] Deploy to Azure

---

## Notes

- All services are currently using in-memory data storage
- Health checks use Microsoft.Extensions.Diagnostics.HealthChecks with custom response format
- Swagger is enabled for all services
- Services can be run independently on different ports
- OrderService has mock product validation (ready for HTTP integration)
- NotificationService simulates delays for realistic behavior
- All services have proper error handling and validation

---

**Last Updated:** 2026-01-16
