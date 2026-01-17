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
- Postman collection available for testing all endpoints (see `POSTMAN_README.md`)

---

## Postman Collection ✅

### Status: Completed

### What Was Created:
1. **Postman Collection** (`Infrastructure-Azure-DotNet.postman_collection.json`)
   - Complete collection with all endpoints from all 3 services
   - Organized by service (ProductService, OrderService, NotificationService)
   - Includes health check endpoints
   - Includes error test cases

2. **Postman Environment** (`Infrastructure-Azure-DotNet.postman_environment.json`)
   - Environment variables for base URLs
   - Easy to switch between environments
   - Default development URLs configured

3. **Documentation** (`POSTMAN_README.md`)
   - Import instructions
   - Testing workflow
   - Example request bodies
   - Troubleshooting guide

### Collection Features:
- **ProductService Endpoints:**
  - Health check
  - Get all products
  - Get product by ID
  - Create product
  - Update product
  - Delete product
  - Error test cases

- **OrderService Endpoints:**
  - Health check
  - Get all orders
  - Get order by ID
  - Create order
  - Update order status
  - Error test cases

- **NotificationService Endpoints:**
  - Health check
  - Get all notifications
  - Get notification by ID
  - Send email notification
  - Send SMS notification
  - Error test cases

### Usage:
1. Import collection and environment files into Postman
2. Select the environment
3. Start all services
4. Test endpoints using the collection

---

---

## Comprehensive .gitignore ✅

### Status: Completed

### What Was Created:
A comprehensive `.gitignore` file covering:

1. **.NET / ASP.NET Core:**
   - Build outputs (bin/, obj/)
   - User-specific files (*.user, *.suo)
   - NuGet packages and cache
   - Test results
   - Build logs

2. **Docker:**
   - docker-compose.override.yml
   - docker-compose.*.local.yml
   - Docker volumes
   - Docker build context

3. **Terraform:**
   - State files (*.tfstate, *.tfstate.*)
   - .terraform/ directory
   - Variable files (*.tfvars) - except examples
   - Terraform lock files
   - Override files

4. **IDE Files:**
   - Visual Studio (.vs/, *.suo, *.user)
   - Visual Studio Code (.vscode/)
   - JetBrains IDEs (.idea/, *.iml)
   - Sublime Text, Vim, Emacs

5. **Environment & Configuration Files:**
   - appsettings.Development.json (with secrets)
   - .env files
   - User secrets
   - Connection strings files
   - Credentials files

6. **Azure Credentials:**
   - Azure CLI (.azure/)
   - Service Principal files
   - Publish settings
   - Key Vault certificates (*.pfx, *.key)
   - Local settings (local.settings.json)

7. **Additional:**
   - Kubernetes secrets
   - Test coverage reports
   - Log files
   - Temporary files
   - OS-specific files

### Important Notes:
- `appsettings.Development.json` is now ignored (if already tracked, remove with: `git rm --cached src/*/appsettings.Development.json`)
- All Terraform state files are ignored
- Docker override files are ignored
- Azure credentials and secrets are protected

---

## Unit Test Projects ✅

### Status: Completed

### What Was Created:
1. **Test Projects Structure:**
   - `ProductService.Tests` - xUnit test project for ProductService
   - `OrderService.Tests` - xUnit test project for OrderService
   - `NotificationService.Tests` - xUnit test project for NotificationService

2. **Project Configuration:**
   - All test projects use xUnit framework
   - Each test project references its corresponding service project
   - Test projects are included in the solution
   - Service projects exclude test files from compilation

3. **Test Files:**
   - `ProductServiceTests.cs` - Basic test structure
   - `OrderServiceTests.cs` - Basic test structure
   - `NotificationServiceTests.cs` - Basic test structure

4. **Project Structure:**
   ```
   src/
   ├── ProductService/
   │   ├── ProductService.csproj
   │   └── ProductService.Tests/
   │       ├── ProductService.Tests.csproj
   │       └── ProductServiceTests.cs
   ├── OrderService/
   │   ├── OrderService.csproj
   │   └── OrderService.Tests/
   │       ├── OrderService.Tests.csproj
   │       └── OrderServiceTests.cs
   └── NotificationService/
       ├── NotificationService.csproj
       └── NotificationService.Tests/
           ├── NotificationService.Tests.csproj
           └── NotificationServiceTests.cs
   ```

### How to Run Tests:

#### Run All Tests:
```bash
dotnet test
```

#### Run Specific Test Project:
```bash
# ProductService tests
dotnet test src/ProductService/ProductService.Tests/ProductService.Tests.csproj

# OrderService tests
dotnet test src/OrderService/OrderService.Tests/OrderService.Tests.csproj

# NotificationService tests
dotnet test src/NotificationService/NotificationService.Tests/NotificationService.Tests.csproj
```

#### Run Tests with Verbose Output:
```bash
dotnet test --verbosity normal
```

#### Run Tests with Coverage:
```bash
dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=opencover
```

#### Run Specific Test:
```bash
dotnet test --filter "FullyQualifiedName~Test1"
```

### Test Framework Details:
- **Framework:** xUnit
- **Test Runner:** VSTest
- **Target Framework:** .NET 8.0
- **Packages:**
  - `xunit` (2.5.3)
  - `xunit.runner.visualstudio` (2.5.3)
  - `Microsoft.NET.Test.Sdk` (17.8.0)
  - `coverlet.collector` (6.0.0) - for code coverage

### Example Test:
```csharp
using Xunit;

namespace ProductService.Tests;

public class ProductServiceTests
{
    [Fact]
    public void Test1()
    {
        Assert.True(true);
    }
}
```

---

## Important Interview Questions & Answers - Unit Testing

### 14. What is Unit Testing?

**Answer:**
Unit testing is a software testing method where individual units (functions, methods, classes) of code are tested in isolation to verify they work correctly.

**Characteristics:**
- Tests individual units in isolation
- Fast execution
- No external dependencies (databases, APIs, file system)
- Repeatable and deterministic
- Should be independent of each other

**Benefits:**
- Early bug detection
- Documentation of code behavior
- Refactoring confidence
- Faster feedback loop
- Better code design (forces testable code)

---

### 15. What is xUnit and why use it?

**Answer:**
xUnit is a free, open-source unit testing framework for .NET, inspired by JUnit and NUnit.

**Features:**
- Simple, clean syntax
- Built-in assertions
- Test discovery
- Parallel test execution
- Extensible architecture

**Comparison with Other Frameworks:**

| Framework | Pros | Cons |
|-----------|------|------|
| **xUnit** | Modern, extensible, parallel execution | Less mature ecosystem |
| **NUnit** | Mature, feature-rich | Older syntax |
| **MSTest** | Built into Visual Studio | Less flexible |

**xUnit Attributes:**
- `[Fact]` - Marks a test method
- `[Theory]` - Parameterized test
- `[InlineData]` - Provides test data
- `[MemberData]` - External data source

---

### 16. What is the AAA Pattern in Unit Testing?

**Answer:**
AAA stands for **Arrange-Act-Assert**, a common pattern for structuring unit tests.

**Structure:**
```csharp
[Fact]
public void GetProduct_ValidId_ReturnsProduct()
{
    // Arrange - Set up test data and dependencies
    var productId = 1;
    var expectedProduct = new Product { Id = 1, Name = "Laptop" };
    
    // Act - Execute the code under test
    var result = _productService.GetProduct(productId);
    
    // Assert - Verify the results
    Assert.NotNull(result);
    Assert.Equal(expectedProduct.Id, result.Id);
    Assert.Equal(expectedProduct.Name, result.Name);
}
```

**Benefits:**
- Clear test structure
- Easy to read and understand
- Separates setup, execution, and verification
- Industry standard pattern

---

### 17. What are Test Doubles (Mocks, Stubs, Fakes)?

**Answer:**
Test doubles are objects that replace real dependencies in tests.

**Types:**

1. **Mock:**
   - Records interactions
   - Verifies method calls
   - Example: `Mock<IProductRepository>`

2. **Stub:**
   - Returns predefined values
   - Doesn't verify interactions
   - Example: Simple implementation returning fixed data

3. **Fake:**
   - Working implementation
   - Simpler than real implementation
   - Example: In-memory database

4. **Spy:**
   - Records method calls
   - Can verify interactions later

**Example with Moq:**
```csharp
var mockRepository = new Mock<IProductRepository>();
mockRepository.Setup(r => r.GetById(1))
    .Returns(new Product { Id = 1, Name = "Laptop" });

var service = new ProductService(mockRepository.Object);
var result = service.GetProduct(1);

Assert.NotNull(result);
mockRepository.Verify(r => r.GetById(1), Times.Once);
```

---

### 18. What is Code Coverage?

**Answer:**
Code coverage measures how much of your code is executed by tests.

**Types:**
- **Line Coverage:** Percentage of lines executed
- **Branch Coverage:** Percentage of branches (if/else) executed
- **Method Coverage:** Percentage of methods called

**Tools:**
- Coverlet (open-source)
- Visual Studio Code Coverage
- dotCover (JetBrains)

**Best Practices:**
- Aim for 70-80% coverage (not 100%)
- Focus on critical business logic
- Don't test framework code
- Coverage doesn't guarantee quality

**Running Coverage:**
```bash
dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=opencover
```

---

### 19. What is Test-Driven Development (TDD)?

**Answer:**
TDD is a development approach where you write tests before writing the implementation code.

**TDD Cycle (Red-Green-Refactor):**

1. **Red:** Write a failing test
2. **Green:** Write minimal code to pass the test
3. **Refactor:** Improve code while keeping tests green

**Benefits:**
- Better test coverage
- Forces good design
- Documentation through tests
- Confidence in refactoring

**Example:**
```csharp
// 1. Red - Write failing test
[Fact]
public void CalculateTotal_WithItems_ReturnsSum()
{
    var cart = new ShoppingCart();
    cart.AddItem(10.00m);
    cart.AddItem(20.00m);
    
    var total = cart.CalculateTotal();
    
    Assert.Equal(30.00m, total);
}

// 2. Green - Write minimal implementation
public class ShoppingCart
{
    private List<decimal> _items = new();
    
    public void AddItem(decimal price) => _items.Add(price);
    
    public decimal CalculateTotal() => _items.Sum();
}

// 3. Refactor - Improve if needed
```

---

### 20. How do you Test Async Methods?

**Answer:**
In xUnit, async test methods should return `Task` or `Task<T>`.

**Example:**
```csharp
[Fact]
public async Task GetProductAsync_ValidId_ReturnsProduct()
{
    // Arrange
    var productId = 1;
    
    // Act
    var result = await _productService.GetProductAsync(productId);
    
    // Assert
    Assert.NotNull(result);
    Assert.Equal(productId, result.Id);
}
```

**Best Practices:**
- Always use `async Task` for async tests
- Use `await` properly
- Test cancellation tokens
- Test timeout scenarios

---

### 21. What is Integration Testing vs Unit Testing?

**Answer:**

| Aspect | Unit Testing | Integration Testing |
|--------|--------------|---------------------|
| **Scope** | Single unit | Multiple units together |
| **Dependencies** | Mocked/Stubbed | Real dependencies |
| **Speed** | Fast | Slower |
| **Purpose** | Verify logic | Verify interactions |
| **Isolation** | Isolated | Not isolated |

**When to Use:**
- **Unit Tests:** Business logic, calculations, validations
- **Integration Tests:** API endpoints, database operations, service interactions

**Example Integration Test:**
```csharp
[Fact]
public async Task CreateProduct_ValidRequest_ReturnsCreatedProduct()
{
    // Uses real database (test database)
    var client = _factory.CreateClient();
    var request = new { name = "Laptop", price = 999.99m };
    
    var response = await client.PostAsJsonAsync("/api/products", request);
    
    response.EnsureSuccessStatusCode();
    var product = await response.Content.ReadFromJsonAsync<Product>();
    Assert.NotNull(product);
}
```

---

### 22. How do you Test Controllers in ASP.NET Core?

**Answer:**
Use `Microsoft.AspNetCore.Mvc.Testing` for integration tests or test controllers directly.

**Integration Testing:**
```csharp
public class ProductsControllerTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly WebApplicationFactory<Program> _factory;
    
    public ProductsControllerTests(WebApplicationFactory<Program> factory)
    {
        _factory = factory;
    }
    
    [Fact]
    public async Task GetProducts_ReturnsOk()
    {
        var client = _factory.CreateClient();
        var response = await client.GetAsync("/api/products");
        
        response.EnsureSuccessStatusCode();
    }
}
```

**Unit Testing (Direct):**
```csharp
[Fact]
public void GetProducts_ReturnsOkResult()
{
    // Arrange
    var controller = new ProductsController();
    
    // Act
    var result = controller.GetProducts();
    
    // Assert
    Assert.IsType<OkObjectResult>(result.Result);
}
```

---

### 23. What are Test Fixtures and Test Collections?

**Answer:**

**Test Fixtures:**
- Shared setup/teardown for multiple tests
- Implement `IDisposable` for cleanup

**Example:**
```csharp
public class DatabaseFixture : IDisposable
{
    public DatabaseFixture()
    {
        // Setup test database
    }
    
    public void Dispose()
    {
        // Cleanup
    }
}

public class MyTests : IClassFixture<DatabaseFixture>
{
    private readonly DatabaseFixture _fixture;
    
    public MyTests(DatabaseFixture fixture)
    {
        _fixture = fixture;
    }
}
```

**Test Collections:**
- Group tests that shouldn't run in parallel
- Useful for database tests

```csharp
[Collection("Database")]
public class ProductRepositoryTests
{
    // Tests that share database
}
```

---

### 24. What Makes a Good Unit Test?

**Answer:**

**Characteristics:**
1. **Fast:** Runs in milliseconds
2. **Isolated:** No dependencies on external systems
3. **Repeatable:** Same result every time
4. **Self-validating:** Pass/fail is clear
5. **Timely:** Written close to implementation

**Naming Convention:**
```
MethodName_Scenario_ExpectedBehavior
```

**Example:**
```csharp
[Fact]
public void CalculateTotal_WithMultipleItems_ReturnsSum()
{
    // Test implementation
}
```

**Common Mistakes:**
- Testing multiple things in one test
- Testing implementation details
- Not testing edge cases
- Slow tests (accessing database/network)
- Unclear test names

---

### 25. How do you Test Exception Scenarios?

**Answer:**
Use `Assert.Throws` or `Assert.ThrowsAsync` in xUnit.

**Example:**
```csharp
[Fact]
public void GetProduct_InvalidId_ThrowsNotFoundException()
{
    // Arrange
    var invalidId = -1;
    
    // Act & Assert
    var exception = Assert.Throws<NotFoundException>(
        () => _productService.GetProduct(invalidId)
    );
    
    Assert.Equal("Product not found", exception.Message);
}

[Fact]
public async Task GetProductAsync_InvalidId_ThrowsNotFoundException()
{
    var exception = await Assert.ThrowsAsync<NotFoundException>(
        async () => await _productService.GetProductAsync(-1)
    );
    
    Assert.NotNull(exception);
}
```

---

## GitHub Actions CI/CD Workflow ✅

### Status: Completed

### What Was Created:
1. **CI/CD Workflow File:** `.github/workflows/ci.yml`
   - Automated testing and building for all services
   - Smart change detection
   - Parallel job execution

2. **Workflow Features:**
   - **Triggers:**
     - Push events to `main` and `develop` branches
     - Pull request events targeting any branch
   
   - **Change Detection:**
     - Detects which services changed using path filters
     - Only runs jobs for changed services
     - Also runs if Shared library changes
   
   - **Service Jobs:**
     - ProductService: restore, build, test
     - OrderService: restore, build, test
     - NotificationService: restore, build, test
   
   - **Matrix Strategy:**
     - Uses .NET 8.0.x (configurable)
     - Easy to add more .NET versions
   
   - **Test Results:**
     - Publishes test results as GitHub checks
     - Shows test summary in PR
     - Uses TRX format for test results

3. **Workflow Structure:**
   ```
   detect-changes (Job 1)
   ├── Detects which services changed
   └── Outputs flags for each service
   
   product-service (Job 2) - Conditional
   ├── Setup .NET
   ├── Restore dependencies
   ├── Build
   ├── Run tests
   └── Publish test results
   
   order-service (Job 3) - Conditional
   ├── Setup .NET
   ├── Restore dependencies
   ├── Build
   ├── Run tests
   └── Publish test results
   
   notification-service (Job 4) - Conditional
   ├── Setup .NET
   ├── Restore dependencies
   ├── Build
   ├── Run tests
   └── Publish test results
   
   build-all (Job 5) - Summary
   ├── Builds entire solution
   └── Creates summary
   ```

### How It Works:

1. **Change Detection:**
   - Uses `dorny/paths-filter@v2` action
   - Monitors paths:
     - `src/ProductService/**` → ProductService job
     - `src/OrderService/**` → OrderService job
     - `src/NotificationService/**` → NotificationService job
     - `src/Shared/**` → All service jobs (since Shared is used by all)

2. **Conditional Execution:**
   - Each service job only runs if:
     - Its own path changed, OR
     - Shared library changed
   - Saves CI time by skipping unchanged services

3. **Test Results Publishing:**
   - Test results appear as GitHub checks
   - Visible in pull requests
   - Shows pass/fail status

### Workflow File Location:
```
.github/workflows/ci.yml
```

### Example Scenarios:

**Scenario 1: Change only ProductService**
- Only ProductService job runs
- OrderService and NotificationService jobs are skipped

**Scenario 2: Change Shared library**
- All three service jobs run (since all depend on Shared)

**Scenario 3: Change multiple services**
- Only changed service jobs run

**Scenario 4: Pull Request**
- Same logic applies
- Test results visible in PR

### Workflow Triggers:

```yaml
on:
  push:
    branches:
      - main
      - develop
  pull_request:
    branches:
      - '*'
```

### Matrix Strategy:

Currently configured for .NET 8.0.x:
```yaml
strategy:
  matrix:
    dotnet-version: ['8.0.x']
```

To add more versions:
```yaml
strategy:
  matrix:
    dotnet-version: ['7.0.x', '8.0.x']
```

### Viewing Results:

1. **GitHub Actions Tab:**
   - Go to repository → Actions tab
   - See all workflow runs
   - Click on a run to see details

2. **Pull Request:**
   - Test results appear as checks
   - Green checkmark = all tests passed
   - Red X = tests failed

3. **Workflow Summary:**
   - Build summary shows which services were tested
   - Test results show pass/fail counts

### Benefits:

- **Efficiency:** Only tests changed services
- **Speed:** Parallel job execution
- **Visibility:** Test results in PRs
- **Reliability:** Automated testing on every push/PR
- **Scalability:** Easy to add more services

---

**Last Updated:** 2026-01-16


