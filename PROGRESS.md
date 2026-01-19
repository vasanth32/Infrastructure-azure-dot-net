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

## Docker Implementation ✅

### Status: Completed

### What Was Created:

1. **Dockerfiles for All Services:**
   - `src/ProductService/Dockerfile` - Multi-stage Dockerfile
   - `src/OrderService/Dockerfile` - Multi-stage Dockerfile
   - `src/NotificationService/Dockerfile` - Multi-stage Dockerfile

2. **.dockerignore Files:**
   - `src/ProductService/.dockerignore`
   - `src/OrderService/.dockerignore`
   - `src/NotificationService/.dockerignore`

3. **Docker Compose:**
   - `docker-compose.yml` - Local development setup
   - `DOCKER_README.md` - Comprehensive Docker guide

### Dockerfile Features:

#### Multi-Stage Build Pattern:
- **Stage 1 (Build):**
  - Uses `mcr.microsoft.com/dotnet/sdk:8.0`
  - Copies `.csproj` and restores dependencies
  - Builds and publishes application
  - Outputs to `/app/publish`

- **Stage 2 (Runtime):**
  - Uses `mcr.microsoft.com/dotnet/aspnet:8.0` (smaller image)
  - Installs curl for health checks
  - Creates non-root user (`appuser`)
  - Copies published files
  - Configures environment
  - Adds health check
  - Runs as non-root user

#### Service-Specific Configuration:

| Service | Container Port | Host Port | Health Check |
|---------|---------------|-----------|--------------|
| ProductService | 8080 | 5000 | http://localhost:5000/health |
| OrderService | 8081 | 5001 | http://localhost:5001/health |
| NotificationService | 8082 | 5002 | http://localhost:5002/health |

#### Security Features:
- Non-root user execution
- Minimal runtime image
- Proper file ownership
- No unnecessary tools in production image

#### Health Checks:
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:PORT/health || exit 1
```

### Docker Compose Configuration:

**Services:**
- ProductService: Port 5000:8080
- OrderService: Port 5001:8081
- NotificationService: Port 5002:8082

**Features:**
- Builds from Dockerfiles
- Health checks configured
- Restart policy: `unless-stopped`
- Bridge network for service communication
- Development environment variables

### How to Use:

#### Build Individual Service:
```bash
cd src/ProductService
docker build -t productservice:latest .
```

#### Run with Docker Compose:
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

#### Test Services:
```bash
# Health checks
curl http://localhost:5000/health  # ProductService
curl http://localhost:5001/health  # OrderService
curl http://localhost:5002/health  # NotificationService

# API endpoints
curl http://localhost:5000/api/products
curl http://localhost:5001/api/orders
curl http://localhost:5002/api/notifications
```

### .dockerignore Benefits:

Excludes from build context:
- Build outputs (bin/, obj/)
- Test projects
- IDE files
- Documentation
- Git files
- Environment files
- Reduces build context size significantly

### Docker Best Practices Implemented:

1. **Multi-stage builds** - Smaller final images
2. **Non-root user** - Better security
3. **Health checks** - Container orchestration support
4. **Layer caching** - Copy .csproj first for better caching
5. **Minimal runtime** - Uses aspnet image (not SDK)
6. **Proper .dockerignore** - Faster builds

---

## Important Interview Questions & Answers - Docker

### 26. What is Docker and why use it?

**Answer:**
Docker is a platform for developing, shipping, and running applications using containerization.

**Benefits:**
- **Consistency:** Same environment across dev, test, production
- **Isolation:** Applications run in isolated containers
- **Portability:** Run anywhere Docker is installed
- **Efficiency:** Lightweight compared to VMs
- **Scalability:** Easy to scale containers

**Key Concepts:**
- **Image:** Template for creating containers
- **Container:** Running instance of an image
- **Dockerfile:** Instructions for building images
- **Docker Compose:** Tool for multi-container applications

---

### 27. What is a Multi-Stage Docker Build?

**Answer:**
Multi-stage builds allow you to use multiple FROM statements in a Dockerfile, creating intermediate images and copying artifacts between stages.

**Benefits:**
- **Smaller final image:** Only include runtime dependencies
- **Better security:** No build tools in production image
- **Faster deployments:** Smaller images = faster pulls

**Example:**
```dockerfile
# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . .
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "MyApp.dll"]
```

**Size Comparison:**
- SDK image: ~800MB
- ASP.NET runtime: ~200MB
- Final image: Only runtime (~200MB)

---

### 28. Why run containers as non-root user?

**Answer:**
Running containers as non-root user is a security best practice.

**Risks of root user:**
- If container is compromised, attacker has root access
- Can modify system files
- Security vulnerabilities are more severe

**Benefits of non-root:**
- Limited permissions if compromised
- Follows principle of least privilege
- Required by many container orchestration platforms

**Implementation:**
```dockerfile
# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Change ownership
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser
```

---

### 29. What is Docker Compose?

**Answer:**
Docker Compose is a tool for defining and running multi-container Docker applications.

**Features:**
- Define services in YAML file
- Start/stop all services with one command
- Configure networking between services
- Manage volumes and environment variables

**Use Cases:**
- Local development
- Testing environments
- CI/CD pipelines
- Simple production deployments

**Example:**
```yaml
services:
  web:
    build: .
    ports:
      - "5000:80"
  db:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: password
```

**Commands:**
- `docker-compose up` - Start services
- `docker-compose down` - Stop services
- `docker-compose logs` - View logs
- `docker-compose ps` - List services

---

### 30. What are Docker Health Checks?

**Answer:**
Health checks allow Docker to determine if a container is healthy and functioning correctly.

**Configuration:**
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
```

**Parameters:**
- `--interval`: Time between checks (default: 30s)
- `--timeout`: Time to wait for response (default: 30s)
- `--start-period`: Grace period before checks start (default: 0s)
- `--retries`: Consecutive failures before unhealthy (default: 3)

**Health States:**
- `starting`: Initial grace period
- `healthy`: Health check passed
- `unhealthy`: Health check failed

**Use Cases:**
- Container orchestration (Kubernetes, Docker Swarm)
- Load balancer health monitoring
- Automatic container restart
- Service discovery

---

### 31. What is .dockerignore and why use it?

**Answer:**
`.dockerignore` is a file that specifies which files and directories should be excluded from the Docker build context.

**Benefits:**
- **Faster builds:** Smaller build context
- **Smaller images:** Excludes unnecessary files
- **Security:** Prevents sensitive files in images
- **Efficiency:** Reduces upload time to Docker daemon

**Common Exclusions:**
- Build outputs (bin/, obj/)
- Test projects
- IDE files
- Documentation
- Git files
- Environment files

**Example:**
```
bin/
obj/
*.Tests/
.vs/
.git/
*.md
```

---

### 32. What is the difference between Docker Image and Container?

**Answer:**

| Aspect | Image | Container |
|--------|-------|-----------|
| **Definition** | Template/Blueprint | Running instance |
| **State** | Immutable, read-only | Mutable, read-write |
| **Creation** | Built from Dockerfile | Created from image |
| **Storage** | Stored in registry | Ephemeral (unless persisted) |
| **Layers** | Multiple layers | Uses image layers + writable layer |

**Analogy:**
- **Image** = Class (template)
- **Container** = Object (instance)

**Lifecycle:**
1. Build image from Dockerfile
2. Create container from image
3. Start container
4. Container runs and can be stopped/removed
5. Image remains (can create more containers)

---

### 33. How do you optimize Docker images?

**Answer:**

**1. Multi-stage builds:**
- Use SDK for building, runtime for production
- Reduces final image size significantly

**2. Layer caching:**
```dockerfile
# Copy dependencies first (changes less frequently)
COPY ["*.csproj", "./"]
RUN dotnet restore

# Copy source code (changes frequently)
COPY . .
RUN dotnet build
```

**3. Use .dockerignore:**
- Exclude unnecessary files
- Smaller build context

**4. Minimal base images:**
- Use `aspnet` instead of `sdk` for runtime
- Use Alpine Linux variants when possible

**5. Combine RUN commands:**
```dockerfile
# Bad
RUN apt-get update
RUN apt-get install -y curl
RUN rm -rf /var/lib/apt/lists/*

# Good
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*
```

**6. Remove unnecessary packages:**
- Clean up package managers
- Remove build tools from runtime

---

### 34. What is Docker Networking?

**Answer:**
Docker provides networking capabilities to connect containers.

**Network Types:**

1. **Bridge (default):**
   - Containers on same network can communicate
   - Isolated from host network
   - Used by Docker Compose

2. **Host:**
   - Container uses host's network directly
   - No network isolation
   - Better performance

3. **None:**
   - No networking
   - Complete isolation

4. **Overlay:**
   - Multi-host networking
   - Used in Docker Swarm

**Docker Compose Networking:**
```yaml
services:
  service1:
    networks:
      - mynetwork
  service2:
    networks:
      - mynetwork

networks:
  mynetwork:
    driver: bridge
```

**Service Discovery:**
- Containers can reach each other by service name
- Example: `http://productservice:8080`

---

### 35. What are Docker Volumes?

**Answer:**
Volumes are the preferred way to persist data in Docker containers.

**Types:**

1. **Named Volumes:**
   ```yaml
   volumes:
     - mydata:/app/data
   ```

2. **Bind Mounts:**
   ```yaml
   volumes:
     - /host/path:/container/path
   ```

3. **Anonymous Volumes:**
   - Created automatically
   - Removed when container removed

**Use Cases:**
- Database data persistence
- Configuration files
- Log files
- Shared data between containers

**Best Practices:**
- Use named volumes for data
- Use bind mounts for development
- Don't store data in container filesystem

---

## Task 20: Terraform Main Configuration ✅

**Status:** ✅ Completed

**Date:** 2026-01-18

### What Was Done:

Created Terraform configuration files for Azure infrastructure deployment:

1. **Directory Structure:**
   ```
   infra/terraform/
   ├── main.tf                    # Main configuration
   ├── variables.tf               # Variable definitions
   ├── outputs.tf                 # Output values
   ├── terraform.tfvars.example   # Example variables
   └── README.md                  # Documentation
   ```

2. **main.tf:**
   - Terraform version requirement (>= 1.0)
   - Azure provider configuration (azurerm ~> 3.0)
   - Resource group creation: `rg-{environment}-microservices-poc`
   - Provider features configuration
   - Commented backend configuration for remote state
   - Commented service principal authentication

3. **variables.tf:**
   - `location` (default: "eastus") with validation for valid Azure regions
   - `environment` (default: "dev") with validation for dev/staging/prod
   - `acr_name` (default: "acrmicroservicespoc") with regex validation
   - `aks_cluster_name` (default: "aks-microservices-poc") with regex validation
   - Optional service principal variables (commented)

4. **outputs.tf:**
   - `resource_group_name` - Name of the resource group
   - `resource_group_location` - Location of the resource group
   - `resource_group_id` - ID of the resource group
   - `aks_cluster_name` - Name of the AKS cluster
   - `acr_name` - Name of the ACR
   - `acr_login_server` - ACR login server URL (placeholder)

5. **terraform.tfvars.example:**
   - Example configuration file with all variables
   - Instructions to copy to terraform.tfvars
   - Commented service principal variables

6. **README.md:**
   - Comprehensive documentation
   - Prerequisites and setup instructions
   - Quick start guide
   - Variable descriptions
   - Authentication options
   - State management guidance
   - Common commands
   - Security best practices
   - Troubleshooting tips

### Key Features:

- **Validation:** All variables include validation rules
- **Naming Convention:** Consistent resource naming pattern
- **Tags:** Resources tagged with Environment, Project, and ManagedBy
- **Security:** Example file for sensitive values, commented service principal support
- **Documentation:** Comprehensive README with best practices

### Code Snippets:

**main.tf:**
```hcl
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "azurerm_resource_group" "microservices" {
  name     = "rg-${var.environment}-microservices-poc"
  location = var.location

  tags = {
    Environment = var.environment
    Project     = "Microservices-POC"
    ManagedBy   = "Terraform"
  }
}
```

**variables.tf:**
```hcl
variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
  
  validation {
    condition = contains([
      "eastus", "eastus2", "westus", "westus2", 
      "centralus", "northcentralus", "southcentralus",
      "westcentralus", "canadacentral", "canadaeast"
    ], var.location)
    error_message = "Location must be a valid Azure region."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}
```

**outputs.tf:**
```hcl
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.microservices.name
}

output "acr_login_server" {
  description = "Login server URL for ACR"
  value       = "${var.acr_name}.azurecr.io"
}
```

### Usage:

1. **Initialize Terraform:**
   ```bash
   cd infra/terraform
   terraform init
   ```

2. **Copy example variables:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. **Edit terraform.tfvars:**
   ```hcl
   location         = "eastus"
   environment      = "dev"
   acr_name         = "acrmicroservicespoc"
   aks_cluster_name = "aks-microservices-poc"
   ```

4. **Plan and Apply:**
   ```bash
   terraform plan
   terraform apply
   ```

5. **View Outputs:**
   ```bash
   terraform output
   ```

---

## Interview Questions: Terraform & Infrastructure as Code

### 1. What is Terraform?

**Answer:**
Terraform is an Infrastructure as Code (IaC) tool by HashiCorp that allows you to define and provision infrastructure using declarative configuration files.

**Key Features:**
- **Declarative:** Describe desired state, not steps
- **Multi-Cloud:** Supports AWS, Azure, GCP, and more
- **State Management:** Tracks infrastructure state
- **Plan & Apply:** Preview changes before applying
- **Idempotent:** Safe to run multiple times

**Example:**
```hcl
resource "azurerm_resource_group" "example" {
  name     = "rg-example"
  location = "eastus"
}
```

---

### 2. What is Infrastructure as Code (IaC)?

**Answer:**
IaC is the practice of managing and provisioning infrastructure through code and automation, rather than manual processes.

**Benefits:**
- **Version Control:** Track infrastructure changes
- **Reproducibility:** Consistent environments
- **Automation:** Reduce human error
- **Documentation:** Code serves as documentation
- **Collaboration:** Team can review and contribute

**Tools:**
- **Terraform:** Declarative, multi-cloud
- **Ansible:** Configuration management
- **ARM Templates:** Azure-specific
- **Bicep:** Azure DSL
- **CloudFormation:** AWS-specific

---

### 3. What is Terraform State?

**Answer:**
Terraform state is a file that tracks the mapping between resources in your configuration and real-world infrastructure.

**Purpose:**
- **Resource Mapping:** Links config to actual resources
- **Metadata:** Stores resource attributes
- **Dependency Tracking:** Maintains resource relationships
- **Performance:** Speeds up operations

**State File Location:**
- **Local:** `terraform.tfstate` (default)
- **Remote:** Azure Storage, S3, Terraform Cloud

**Best Practices:**
- **Remote State:** Use for teams
- **State Locking:** Prevent concurrent modifications
- **Backup:** Regularly backup state files
- **Never Edit Manually:** Use Terraform commands

**Example:**
```hcl
backend "azurerm" {
  resource_group_name  = "rg-terraform-state"
  storage_account_name = "tfstate"
  container_name       = "tfstate"
  key                  = "microservices.terraform.tfstate"
}
```

---

### 4. What are Terraform Providers?

**Answer:**
Providers are plugins that Terraform uses to interact with cloud platforms, SaaS services, and APIs.

**Common Providers:**
- **azurerm:** Azure resources
- **aws:** AWS resources
- **google:** GCP resources
- **kubernetes:** Kubernetes clusters
- **docker:** Docker containers

**Configuration:**
```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

**Version Constraints:**
- `~> 3.0` - Allow 3.x, not 4.0
- `>= 3.0` - Minimum version
- `= 3.0.0` - Exact version

---

### 5. What are Terraform Variables?

**Answer:**
Variables allow you to parameterize your Terraform configurations, making them reusable and flexible.

**Types:**
1. **Input Variables:** Defined in `variables.tf`
2. **Output Variables:** Defined in `outputs.tf`
3. **Local Values:** Computed values within modules

**Variable Types:**
- `string` - Text values
- `number` - Numeric values
- `bool` - Boolean values
- `list` - Ordered collection
- `map` - Key-value pairs
- `object` - Structured data

**Example:**
```hcl
variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
  
  validation {
    condition     = contains(["eastus", "westus"], var.location)
    error_message = "Location must be eastus or westus."
  }
}
```

**Variable Sources:**
1. `terraform.tfvars` file
2. Command line: `terraform apply -var="location=westus"`
3. Environment variables: `TF_VAR_location`
4. Default values in variable definition

---

### 6. What is Terraform Plan?

**Answer:**
`terraform plan` creates an execution plan showing what Terraform will do when you run `terraform apply`.

**Purpose:**
- **Preview Changes:** See what will be created/modified/destroyed
- **Validation:** Catch errors before applying
- **Review:** Team can review changes
- **Safety:** Prevent accidental changes

**Output:**
```
Terraform will perform the following actions:

  # azurerm_resource_group.microservices will be created
  + resource "azurerm_resource_group" "microservices" {
      + id       = (known after apply)
      + location = "eastus"
      + name     = "rg-dev-microservices-poc"
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

**Best Practices:**
- Always run `terraform plan` before `apply`
- Review plan output carefully
- Use `-out` flag to save plan: `terraform plan -out=tfplan`
- Apply saved plan: `terraform apply tfplan`

---

### 7. What is Terraform Apply?

**Answer:**
`terraform apply` executes the changes proposed in a Terraform plan, creating, modifying, or destroying resources.

**Process:**
1. **Plan:** Creates execution plan (if not provided)
2. **Prompt:** Asks for confirmation (unless `-auto-approve`)
3. **Execute:** Applies changes to infrastructure
4. **Update State:** Updates state file with results

**Example:**
```bash
terraform apply
# Review plan, type 'yes' to confirm

terraform apply -auto-approve
# Skip confirmation prompt
```

**Safety Features:**
- **Confirmation:** Requires user confirmation
- **Plan First:** Shows what will change
- **State Locking:** Prevents concurrent modifications
- **Rollback:** Can destroy and recreate if needed

---

### 8. What are Terraform Modules?

**Answer:**
Modules are containers for multiple resources that are used together, allowing you to create reusable, composable infrastructure components.

**Benefits:**
- **Reusability:** Use same module multiple times
- **Organization:** Group related resources
- **Abstraction:** Hide complexity
- **Versioning:** Tag and version modules

**Module Structure:**
```
modules/
  aks/
    main.tf
    variables.tf
    outputs.tf
    README.md
```

**Using Modules:**
```hcl
module "aks_cluster" {
  source = "./modules/aks"
  
  cluster_name = "aks-microservices"
  location     = "eastus"
  node_count   = 3
}
```

**Module Sources:**
- Local: `./modules/aks`
- GitHub: `github.com/org/repo//modules/aks?ref=v1.0.0`
- Terraform Registry: `hashicorp/aks/azurerm`
- Azure DevOps: `git::https://dev.azure.com/org/repo`

---

### 9. What is Terraform Workspace?

**Answer:**
Terraform workspaces allow you to manage multiple distinct sets of infrastructure resources with the same configuration.

**Use Cases:**
- **Environments:** dev, staging, prod
- **Feature Branches:** Test infrastructure changes
- **Regions:** Different Azure regions

**Commands:**
```bash
# List workspaces
terraform workspace list

# Create new workspace
terraform workspace new dev

# Select workspace
terraform workspace select dev

# Show current workspace
terraform workspace show

# Delete workspace
terraform workspace delete dev
```

**Workspace in Config:**
```hcl
resource "azurerm_resource_group" "example" {
  name     = "rg-${terraform.workspace}-example"
  location = "eastus"
}
```

**Best Practices:**
- Use for environments (dev/staging/prod)
- Don't use for feature branches (use separate state)
- Combine with remote state for teams

---

### 10. What is Terraform Destroy?

**Answer:**
`terraform destroy` removes all resources defined in your Terraform configuration.

**Usage:**
```bash
terraform destroy
# Review plan, type 'yes' to confirm

terraform destroy -auto-approve
# Skip confirmation
```

**Process:**
1. Creates destruction plan
2. Shows resources to be destroyed
3. Prompts for confirmation
4. Destroys resources in reverse dependency order
5. Updates state file

**Safety:**
- **Confirmation Required:** Prevents accidental deletion
- **Dependency Order:** Destroys in correct order
- **State Update:** Removes from state after destruction

**Best Practices:**
- Always review destruction plan
- Backup state before destroying
- Use `-target` to destroy specific resources
- Consider using `prevent_destroy` lifecycle rule

---

### 11. What are Terraform Lifecycle Rules?

**Answer:**
Lifecycle rules control how Terraform handles resource creation, updates, and destruction.

**Common Rules:**
1. **create_before_destroy:**
   ```hcl
   lifecycle {
     create_before_destroy = true
   }
   ```
   - Creates new resource before destroying old one
   - Prevents downtime during updates

2. **prevent_destroy:**
   ```hcl
   lifecycle {
     prevent_destroy = true
   }
   ```
   - Prevents accidental deletion
   - Must remove from config first

3. **ignore_changes:**
   ```hcl
   lifecycle {
     ignore_changes = [tags]
   }
   ```
   - Ignores changes to specified attributes
   - Useful for externally managed attributes

4. **replace_triggered_by:**
   ```hcl
   lifecycle {
     replace_triggered_by = [azurerm_virtual_network.example]
   }
   ```
   - Forces replacement when referenced resource changes

**Example:**
```hcl
resource "azurerm_resource_group" "example" {
  name     = "rg-example"
  location = "eastus"
  
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
    ignore_changes        = [tags]
  }
}
```

---

### 12. What is Terraform State Locking?

**Answer:**
State locking prevents multiple users from modifying Terraform state simultaneously, avoiding conflicts and corruption.

**How It Works:**
- Terraform acquires a lock before modifying state
- Other operations wait until lock is released
- Lock is released after operation completes

**Backend Support:**
- **Azure Storage:** Uses blob lease
- **AWS S3:** Uses DynamoDB table
- **Terraform Cloud:** Built-in locking
- **Local:** File-based locking (limited)

**Example (Azure Storage):**
```hcl
backend "azurerm" {
  resource_group_name  = "rg-terraform-state"
  storage_account_name = "tfstate"
  container_name       = "tfstate"
  key                  = "terraform.tfstate"
}
```

**Force Unlock (Use with Caution):**
```bash
terraform force-unlock <LOCK_ID>
```

**Best Practices:**
- Always use remote state with locking
- Never disable locking
- Wait for locks to release naturally
- Use force-unlock only in emergencies

---

### 13. What are Terraform Data Sources?

**Answer:**
Data sources allow Terraform to fetch information from existing resources or external systems.

**Purpose:**
- **Read Existing Resources:** Get info about existing infrastructure
- **External Data:** Fetch data from APIs, files, etc.
- **Reference Resources:** Use in other resources

**Example:**
```hcl
# Get existing resource group
data "azurerm_resource_group" "existing" {
  name = "rg-existing"
}

# Use in resource
resource "azurerm_storage_account" "example" {
  name                = "stexample"
  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location
  account_tier        = "Standard"
  account_replication_type = "LRS"
}
```

**Common Data Sources:**
- `azurerm_resource_group` - Existing resource group
- `azurerm_client_config` - Current Azure client config
- `azurerm_subscription` - Subscription information
- `http` - HTTP endpoint data
- `local_file` - Local file contents

**Difference from Resources:**
- **Resources:** Create/manage infrastructure
- **Data Sources:** Read existing infrastructure

---

### 14. What is Terraform Remote State?

**Answer:**
Remote state stores Terraform state in a remote backend (e.g., Azure Storage, S3) instead of locally.

**Benefits:**
- **Team Collaboration:** Shared state for team
- **State Locking:** Prevents concurrent modifications
- **Backup:** Automatic backup in cloud storage
- **Security:** Encrypted at rest
- **CI/CD Integration:** Works with automation

**Backend Types:**
1. **Azure Storage:**
   ```hcl
   backend "azurerm" {
     resource_group_name  = "rg-terraform-state"
     storage_account_name = "tfstate"
     container_name       = "tfstate"
     key                  = "terraform.tfstate"
   }
   ```

2. **AWS S3:**
   ```hcl
   backend "s3" {
     bucket = "terraform-state"
     key    = "terraform.tfstate"
     region = "us-east-1"
   }
   ```

3. **Terraform Cloud:**
   ```hcl
   backend "remote" {
     organization = "myorg"
     workspaces {
       name = "microservices"
     }
   }
   ```

**Migration:**
```bash
# Initialize with new backend
terraform init -migrate-state
```

---

### 15. What is Terraform Validate?

**Answer:**
`terraform validate` checks whether a configuration is syntactically valid and internally consistent.

**What It Checks:**
- **Syntax:** Valid HCL syntax
- **References:** Valid variable/resource references
- **Types:** Correct data types
- **Required Arguments:** All required arguments present

**Usage:**
```bash
terraform validate
```

**Output:**
```
Success! The configuration is valid.
```

**Limitations:**
- Doesn't check provider connectivity
- Doesn't validate resource existence
- Doesn't check permissions
- Only validates configuration structure

**Best Practices:**
- Run before `terraform plan`
- Include in CI/CD pipeline
- Use `terraform fmt` to format code
- Use `terraform fmt -check` to verify formatting

---

### 16. What is Terraform Fmt?

**Answer:**
`terraform fmt` automatically formats Terraform configuration files to a canonical format and style.

**Usage:**
```bash
# Format all .tf files in current directory
terraform fmt

# Format specific file
terraform fmt main.tf

# Check formatting without modifying
terraform fmt -check

# Recursive formatting
terraform fmt -recursive
```

**What It Does:**
- Indentation (2 spaces)
- Alignment
- Spacing
- Line breaks
- Consistent style

**Example:**
```hcl
# Before
resource"azurerm_resource_group"example{
name="rg-example"
location="eastus"
}

# After
resource "azurerm_resource_group" "example" {
  name     = "rg-example"
  location = "eastus"
}
```

**Best Practices:**
- Run before committing code
- Use `-check` in CI/CD
- Use `-recursive` for modules
- Configure editor to format on save

---

### 17. What are Terraform Outputs?

**Answer:**
Outputs expose values from your Terraform configuration, making them available to other configurations or for display.

**Purpose:**
- **Display Values:** Show important resource information
- **Module Communication:** Pass values between modules
- **Remote State:** Access outputs from other configurations
- **CI/CD Integration:** Use in pipelines

**Example:**
```hcl
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.microservices.name
}

output "acr_login_server" {
  description = "ACR login server URL"
  value       = "${var.acr_name}.azurecr.io"
  sensitive   = false
}
```

**Viewing Outputs:**
```bash
# Show all outputs
terraform output

# Show specific output
terraform output resource_group_name

# Show as JSON
terraform output -json
```

**Sensitive Outputs:**
```hcl
output "connection_string" {
  value     = azurerm_storage_account.example.primary_connection_string
  sensitive = true
}
```

**Remote State Outputs:**
```hcl
data "terraform_remote_state" "network" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstate"
    container_name       = "tfstate"
    key                  = "network.terraform.tfstate"
  }
}

resource "azurerm_virtual_machine" "example" {
  # Use output from remote state
  subnet_id = data.terraform_remote_state.network.outputs.subnet_id
}
```

---

### 18. What is Terraform Refresh?

**Answer:**
`terraform refresh` updates the state file to match the actual state of infrastructure, without making any changes.

**Purpose:**
- **Sync State:** Update state with real infrastructure
- **Detect Drift:** Find manual changes
- **Recovery:** Fix state after manual changes

**Usage:**
```bash
terraform refresh
```

**What It Does:**
1. Queries all resources in state
2. Compares with actual infrastructure
3. Updates state file with current values
4. Doesn't modify infrastructure

**When to Use:**
- After manual infrastructure changes
- To detect configuration drift
- To recover from state corruption
- Before planning changes

**Note:**
- `terraform plan` and `terraform apply` automatically refresh state
- Rarely need to run manually
- Use `-target` to refresh specific resources

---

### 19. What is Configuration Drift?

**Answer:**
Configuration drift occurs when the actual infrastructure differs from what Terraform expects based on the state file.

**Causes:**
- Manual changes to resources
- External processes modifying infrastructure
- Provider bugs
- State file corruption

**Detection:**
```bash
terraform plan
# Shows differences between state and actual infrastructure
```

**Prevention:**
- **No Manual Changes:** Always use Terraform
- **State Locking:** Prevent concurrent modifications
- **Access Control:** Limit who can modify resources
- **Monitoring:** Regular drift detection

**Resolution:**
1. **Import:** Import manually created resources
2. **Refresh:** Update state to match reality
3. **Recreate:** Destroy and recreate resources
4. **Taint:** Force recreation of specific resources

**Example:**
```bash
# Detect drift
terraform plan
# Shows: resource will be updated in-place

# Option 1: Refresh state (accept manual changes)
terraform refresh

# Option 2: Apply to revert to desired state
terraform apply
```

---

### 20. What is Terraform Import ?

**Answer:**
`terraform import` brings existing infrastructure under Terraform management by adding it to the state file.

**Purpose:**
- **Migrate Existing Resources:** Import manually created resources
- **Adopt Infrastructure:** Start managing with Terraform
- **Recovery:** Recover from lost state

**Usage:**
```bash
terraform import <resource_type>.<resource_name> <resource_id>
```

**Example:**
```bash
# Import existing resource group
terraform import azurerm_resource_group.microservices /subscriptions/xxx/resourceGroups/rg-dev-microservices-poc
```

**Process:**
1. Add resource to configuration
2. Run `terraform import`
3. Terraform adds resource to state
4. Run `terraform plan` to see differences
5. Update configuration to match actual resource
6. Run `terraform apply` to sync

**Limitations:**
- Doesn't automatically update configuration
- Must manually match configuration to imported resource
- Some resources can't be imported
- Complex resources may require multiple imports

**Best Practices:**
- Import one resource at a time
- Verify import with `terraform show`
- Update configuration immediately after import
- Test with `terraform plan` before applying

---

## Task 21: AKS Cluster Module ✅

**Status:** ✅ Completed

**Date:** 2026-01-18

### What Was Done:

Created a reusable Terraform module for Azure Kubernetes Service (AKS) cluster with comprehensive configuration:

1. **Directory Structure:**
   ```
   infra/terraform/modules/aks/
   ├── main.tf          # AKS cluster and node pools
   ├── variables.tf     # Module input variables
   ├── outputs.tf       # Module outputs
   └── README.md        # Module documentation
   ```

2. **main.tf Features:**
   - **AKS Cluster:**
     - System-assigned managed identity (default)
     - Optional service principal support
     - Kubernetes version configuration
     - DNS prefix configuration
   
   - **System Node Pool (Default Pool):**
     - 1 node by default (configurable)
     - Taints: `CriticalAddonsOnly=true:NoSchedule`
     - Labels: `kubernetes.azure.com/mode=system`
     - Upgrade settings with surge protection
   
   - **User Node Pool:**
     - 2-3 nodes by default (configurable)
     - Auto-scaling support (min/max counts)
     - Custom labels and taints
     - Upgrade settings with surge protection
   
   - **Network Configuration:**
     - Network plugin: `azure` (Azure CNI)
     - Optional network policy (Calico)
     - Standard load balancer
     - Configurable service CIDR and DNS service IP
   
   - **RBAC Configuration:**
     - RBAC enabled by default
     - Azure AD integration with Azure RBAC
     - Admin group object IDs support
   
   - **Azure Monitor:**
     - Container Insights integration
     - Log Analytics workspace support
     - OMS agent configuration
   
   - **Additional Features:**
     - API server authorized IP ranges
     - Automatic channel upgrade
     - HTTP application routing addon (optional)
     - Comprehensive tagging

3. **variables.tf:**
   - **Required Variables:**
     - `cluster_name` - AKS cluster name
     - `location` - Azure region
     - `resource_group_name` - Resource group name
   
   - **Optional Variables:**
     - `dns_prefix` - DNS prefix (default: "aks")
     - `kubernetes_version` - Kubernetes version (default: latest)
     - `subnet_id` - Subnet for nodes
     - `system_node_count` - System pool node count (default: 1)
     - `system_node_vm_size` - System pool VM size (default: "Standard_DS2_v2")
     - `user_node_count` - User pool node count (default: 2)
     - `user_node_min_count` - Min nodes for autoscaling (default: 2)
     - `user_node_max_count` - Max nodes for autoscaling (default: 3)
     - `user_node_vm_size` - User pool VM size (default: "Standard_DS2_v2")
     - `enable_user_pool_autoscaling` - Enable autoscaling (default: true)
     - `enable_azure_rbac` - Enable Azure RBAC (default: true)
     - `enable_azure_monitor` - Enable Azure Monitor (default: true)
     - `log_analytics_workspace_id` - Log Analytics workspace ID
     - `admin_group_object_ids` - Azure AD admin group IDs
     - `tags` - Resource tags
     - All variables include validation rules

4. **outputs.tf:**
   - **Cluster Information:**
     - `cluster_id` - Cluster ID
     - `cluster_name` - Cluster name
     - `cluster_fqdn` - Cluster FQDN
     - `cluster_private_fqdn` - Private FQDN
   
   - **Kubernetes Configuration (Sensitive):**
     - `kube_config` - Raw Kubernetes config
     - `host` - Kubernetes server host
     - `client_key` - Client authentication key
     - `client_certificate` - Client authentication certificate
     - `cluster_ca_certificate` - Cluster CA certificate
   
   - **Node Pool Information:**
     - `system_node_pool_id` - System pool ID
     - `user_node_pool_id` - User pool ID
     - `user_node_pool_name` - User pool name
   
   - **Additional Outputs:**
     - `cluster_identity` - Managed identity details
     - `network_plugin` - Network plugin used
     - `network_policy` - Network policy used
     - `rbac_enabled` - RBAC status
     - `azure_rbac_enabled` - Azure RBAC status
     - `kubernetes_version` - Kubernetes version
     - `portal_fqdn` - Azure Portal URL

5. **README.md:**
   - Comprehensive module documentation
   - Usage examples
   - Input/output reference
   - Node pool explanations
   - Network configuration details
   - Security best practices
   - Complete setup example
   - Troubleshooting guide

### Key Features:

- **Managed Identity:** Uses system-assigned managed identity (more secure than service principal)
- **Dual Node Pools:** Separate system and user pools for better resource isolation
- **Auto-scaling:** User pool supports horizontal pod autoscaling
- **RBAC:** Full RBAC with optional Azure AD integration
- **Monitoring:** Azure Monitor (Container Insights) integration
- **Network:** Azure CNI with optional network policies
- **Security:** API server IP restrictions, upgrade settings, surge protection
- **Flexibility:** Highly configurable with sensible defaults

### Code Snippets:

**main.tf - AKS Cluster:**
```hcl
resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name                = "systempool"
    node_count          = var.system_node_count
    vm_size             = var.system_node_vm_size
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = false
    os_disk_size_gb     = var.system_node_disk_size
    vnet_subnet_id      = var.subnet_id

    node_labels = {
      "kubernetes.azure.com/mode" = "system"
    }

    node_taints = var.system_node_taints

    upgrade_settings {
      max_surge = "33%"
    }
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = var.enable_network_policy ? "azure" : null
    load_balancer_sku = "standard"
    service_cidr      = var.service_cidr
    dns_service_ip    = var.dns_service_ip
  }

  role_based_access_control_enabled = true

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = var.enable_azure_rbac
    admin_group_object_ids = var.admin_group_object_ids
  }

  oms_agent {
    enabled                    = var.enable_azure_monitor
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }
}
```

**main.tf - User Node Pool:**
```hcl
resource "azurerm_kubernetes_cluster_node_pool" "userpool" {
  name                  = "userpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  node_count            = var.user_node_count
  vm_size               = var.user_node_vm_size
  os_type               = "Linux"
  os_disk_size_gb       = var.user_node_disk_size
  vnet_subnet_id        = var.subnet_id

  enable_auto_scaling = var.enable_user_pool_autoscaling
  min_count           = var.enable_user_pool_autoscaling ? var.user_node_min_count : null
  max_count           = var.enable_user_pool_autoscaling ? var.user_node_max_count : null

  node_labels = merge(
    {
      "kubernetes.azure.com/mode" = "user"
    },
    var.user_node_labels
  )

  node_taints = var.user_node_taints

  upgrade_settings {
    max_surge = "33%"
  }
}
```

**outputs.tf - Kubernetes Configuration:**
```hcl
output "kube_config" {
  description = "Raw Kubernetes config to be used by kubectl"
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true
}

output "host" {
  description = "Kubernetes cluster server host"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].host
  sensitive   = true
}

output "client_key" {
  description = "Base64 encoded private key for authentication"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].client_key
  sensitive   = true
}

output "client_certificate" {
  description = "Base64 encoded public certificate for authentication"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].client_certificate
  sensitive   = true
}
```

### Usage Example:

```hcl
module "aks" {
  source = "./modules/aks"

  cluster_name         = "aks-microservices-poc"
  location             = "eastus"
  resource_group_name  = azurerm_resource_group.microservices.name
  dns_prefix           = "aks-microservices"

  # System Node Pool
  system_node_count    = 1
  system_node_vm_size  = "Standard_DS2_v2"

  # User Node Pool
  user_node_count      = 2
  user_node_min_count  = 2
  user_node_max_count  = 3
  user_node_vm_size    = "Standard_DS2_v2"
  enable_user_pool_autoscaling = true

  # Network
  subnet_id            = azurerm_subnet.aks.id

  # RBAC
  enable_azure_rbac    = true
  admin_group_object_ids = ["group-object-id"]

  # Azure Monitor
  enable_azure_monitor = true
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  tags = {
    Environment = "dev"
    Project     = "Microservices-POC"
  }
}
```

### Accessing the Cluster:

```bash
# Get kubeconfig from Terraform output
terraform output -raw kube_config > ~/.kube/config-aks

# Set KUBECONFIG
export KUBECONFIG=~/.kube/config-aks

# Verify access
kubectl get nodes
kubectl get pods --all-namespaces
```

---

## Interview Questions: Azure Kubernetes Service (AKS)

### 1. What is Azure Kubernetes Service (AKS)?

**Answer:**
AKS is a managed Kubernetes service provided by Microsoft Azure that simplifies deploying, managing, and scaling containerized applications.

**Key Features:**
- **Managed Control Plane:** Azure manages the Kubernetes control plane
- **Auto-scaling:** Automatic scaling of nodes and pods
- **Integrated Services:** Azure Monitor, Azure AD, Azure Container Registry
- **Security:** RBAC, network policies, pod security policies
- **Updates:** Automated Kubernetes version updates

**Benefits:**
- Reduced operational overhead
- High availability
- Security and compliance
- Cost optimization
- Integration with Azure ecosystem

---

### 2. What are Node Pools in AKS?

**Answer:**
Node pools are groups of nodes (VMs) in an AKS cluster that have the same configuration.

**Types:**
1. **System Node Pool:**
   - Runs system pods (kube-system, ingress controllers)
   - Minimum 1 node required
   - Should have taints to prevent user workloads

2. **User Node Pool:**
   - Runs application workloads
   - Can have multiple user pools
   - Can have different VM sizes and configurations

**Use Cases:**
- **Separate Workloads:** System vs. application pods
- **Different VM Sizes:** CPU-intensive vs. memory-intensive workloads
- **Different Zones:** Multi-availability zone deployments
- **Spot Instances:** Cost optimization with spot VMs

**Example:**
```hcl
# System pool
default_node_pool {
  name       = "systempool"
  node_count = 1
  vm_size    = "Standard_DS2_v2"
  node_taints = ["CriticalAddonsOnly=true:NoSchedule"]
}

# User pool
resource "azurerm_kubernetes_cluster_node_pool" "userpool" {
  name                  = "userpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  node_count            = 3
  vm_size               = "Standard_DS4_v2"
}
```

---

### 3. What is RBAC in Kubernetes?

**Answer:**
RBAC (Role-Based Access Control) is a method of regulating access to Kubernetes resources based on roles assigned to users or service accounts.

**Components:**
1. **Roles:** Define permissions within a namespace
2. **ClusterRoles:** Define permissions cluster-wide
3. **RoleBindings:** Bind roles to users/groups in a namespace
4. **ClusterRoleBindings:** Bind cluster roles cluster-wide

**Azure RBAC Integration:**
- Use Azure AD for authentication
- Azure AD groups for authorization
- No need to manage Kubernetes service accounts
- Integrated with Azure policies

**Example:**
```hcl
azure_active_directory_role_based_access_control {
  managed                = true
  azure_rbac_enabled     = true
  admin_group_object_ids = ["group-id-1", "group-id-2"]
}
```

**Benefits:**
- Centralized identity management
- Single sign-on (SSO)
- Audit logging
- Conditional access policies

---

### 4. What is Azure Monitor for Containers?

**Answer:**
Azure Monitor for Containers (Container Insights) provides comprehensive monitoring for AKS clusters and container workloads.

**Features:**
- **Performance Metrics:** CPU, memory, disk, network
- **Log Collection:** Container logs, Kubernetes events
- **Health Monitoring:** Node and pod health
- **Alerting:** Custom alerts based on metrics
- **Dashboards:** Pre-built and custom dashboards

**Configuration:**
```hcl
oms_agent {
  enabled                    = true
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
}
```

**Metrics Collected:**
- Node metrics (CPU, memory, disk)
- Pod metrics (CPU, memory, network)
- Container metrics
- Kubernetes events
- Application logs

**Benefits:**
- Proactive issue detection
- Performance optimization
- Cost analysis
- Compliance and auditing

---

### 5. What is Azure CNI?

**Answer:**
Azure CNI (Container Networking Interface) is a networking plugin for AKS that provides native Azure networking capabilities.

**Features:**
- **VNet Integration:** Pods get IPs from Azure VNet
- **Network Policies:** Pod-to-pod communication control
- **Service Integration:** Azure Load Balancer, Application Gateway
- **Security Groups:** NSG rules apply to pods

**Comparison with Kubenet:**
- **Azure CNI:**
  - Pods get VNet IPs
  - Better for compliance
  - More IP addresses needed
  - Network policies supported

- **Kubenet:**
  - Pods get private IPs
  - Simpler setup
  - Fewer IP addresses needed
  - Limited network policy support

**Configuration:**
```hcl
network_profile {
  network_plugin = "azure"
  network_policy = "azure"  # Optional: Calico
}
```

**Use Cases:**
- Compliance requirements
- Integration with Azure services
- Network policies needed
- Large-scale deployments

---

### 6. What is Managed Identity in AKS?

**Answer:**
Managed Identity is an Azure feature that provides AKS clusters with an automatically managed identity in Azure AD.

**Types:**
1. **System-Assigned:** Created and managed by Azure
2. **User-Assigned:** Created separately and assigned to cluster

**Benefits:**
- **No Secrets:** No need to manage service principal secrets
- **Automatic Rotation:** Azure manages credential rotation
- **Secure:** Integrated with Azure AD
- **Simplified:** Easier to configure and maintain

**Configuration:**
```hcl
identity {
  type = "SystemAssigned"
}
```

**Use Cases:**
- Accessing Azure Container Registry (ACR)
- Accessing Azure Key Vault
- Accessing Azure Storage
- Accessing other Azure services

**Permissions:**
- ACR pull/push
- Key Vault access
- Storage account access
- Resource group contributor

---

### 7. What is Auto-scaling in AKS?

**Answer:**
Auto-scaling in AKS allows automatic adjustment of node count based on resource demands.

**Types:**
1. **Cluster Autoscaler:**
   - Scales node pools based on pod scheduling needs
   - Adds nodes when pods can't be scheduled
   - Removes nodes when underutilized

2. **Horizontal Pod Autoscaler (HPA):**
   - Scales pod replicas based on metrics
   - CPU, memory, custom metrics
   - Works with Cluster Autoscaler

3. **Vertical Pod Autoscaler (VPA):**
   - Adjusts pod resource requests/limits
   - Not commonly used in AKS

**Configuration:**
```hcl
resource "azurerm_kubernetes_cluster_node_pool" "userpool" {
  enable_auto_scaling = true
  min_count           = 2
  max_count           = 10
  node_count          = 2  # Initial count
}
```

**Benefits:**
- Cost optimization
- Performance optimization
- Automatic resource management
- High availability

**Considerations:**
- Set appropriate min/max counts
- Monitor scaling events
- Consider pod disruption budgets
- Test scaling behavior

---

### 8. What are Taints and Tolerations?

**Answer:**
Taints and tolerations are Kubernetes mechanisms to control which pods can be scheduled on which nodes.

**Taints:**
- Applied to nodes
- Prevent pods from being scheduled (unless they have matching toleration)
- Three effects: `NoSchedule`, `PreferNoSchedule`, `NoExecute`

**Tolerations:**
- Applied to pods
- Allow pods to be scheduled on tainted nodes
- Must match node taint

**Example:**
```hcl
# Node with taint
default_node_pool {
  node_taints = ["CriticalAddonsOnly=true:NoSchedule"]
}

# Pod with toleration
apiVersion: v1
kind: Pod
spec:
  tolerations:
  - key: "CriticalAddonsOnly"
    operator: "Equal"
    value: "true"
    effect: "NoSchedule"
```

**Use Cases:**
- **System Nodes:** Only system pods
- **GPU Nodes:** Only GPU workloads
- **Spot Instances:** Only fault-tolerant workloads
- **Dedicated Nodes:** Specific application types

---

### 9. What is Kubernetes Upgrade in AKS?

**Answer:**
AKS supports upgrading Kubernetes versions to get new features, security patches, and bug fixes.

**Upgrade Types:**
1. **Control Plane Upgrade:**
   - Upgrades API server, etcd, controller manager
   - Managed by Azure
   - Can be automated

2. **Node Pool Upgrade:**
   - Upgrades node OS and Kubernetes version
   - Can be done node-by-node
   - Supports surge for zero downtime

**Upgrade Channels:**
- **patch:** Latest patch version
- **rapid:** Latest minor version (testing)
- **stable:** Latest stable minor version (recommended)
- **node-image:** Node image updates only
- **none:** Manual upgrades only

**Configuration:**
```hcl
automatic_channel_upgrade = "stable"
```

**Upgrade Process:**
1. Upgrade control plane
2. Upgrade node pools (one at a time)
3. Use surge settings for zero downtime
4. Verify cluster health

**Surge Settings:**
```hcl
upgrade_settings {
  max_surge = "33%"  # Create 33% extra nodes during upgrade
}
```

---

### 10. What is Network Policy in AKS?

**Answer:**
Network policies control pod-to-pod and pod-to-service communication in AKS clusters.

**Providers:**
1. **Azure Network Policy:**
   - Native Azure implementation
   - Uses Azure Network Security Groups
   - Integrated with Azure CNI

2. **Calico Network Policy:**
   - Open-source implementation
   - More features (global network policies, egress policies)
   - Works with both Azure CNI and Kubenet

**Configuration:**
```hcl
network_profile {
  network_plugin = "azure"
  network_policy = "azure"  # or "calico"
}
```

**Example Policy:**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
```

**Use Cases:**
- **Micro-segmentation:** Isolate workloads
- **Compliance:** Meet security requirements
- **Multi-tenancy:** Separate tenant workloads
- **Security:** Limit attack surface

---

### 11. What is Azure Container Registry (ACR) Integration with AKS?

**Answer:**
ACR integration allows AKS clusters to pull container images from Azure Container Registry without managing credentials.

**Integration Methods:**
1. **Managed Identity:**
   - AKS cluster uses managed identity
   - ACR grants pull permissions to identity
   - No secrets required

2. **Service Principal:**
   - AKS uses service principal
   - ACR grants pull permissions
   - Requires secret management

**Configuration:**
```hcl
# Grant AKS managed identity ACR pull permissions
resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.main.identity[0].principal_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.main.id
}
```

**Benefits:**
- No image pull secrets needed
- Secure authentication
- Automatic credential rotation
- Simplified configuration

---

### 12. What is Pod Security Policy in AKS?

**Answer:**
Pod Security Policies (PSP) are being deprecated in favor of Pod Security Standards (PSS) in Kubernetes 1.23+.

**Pod Security Standards:**
- **Privileged:** No restrictions
- **Baseline:** Prevents known privilege escalations
- **Restricted:** Highly restrictive, follows hardening best practices

**Configuration:**
```hcl
# Enable Pod Security Standards
api_server_authorized_ip_ranges = []
```

**Namespace-Level:**
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: restricted-ns
  labels:
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/audit: restricted
    pod-security.kubernetes.io/warn: restricted
```

**Best Practices:**
- Run as non-root user
- Read-only root filesystem
- Drop unnecessary capabilities
- Use security contexts
- Limit host access

---

### 13. What is Ingress in AKS?

**Answer:**
Ingress is a Kubernetes resource that provides HTTP/HTTPS routing to services within the cluster.

**Ingress Controllers:**
1. **NGINX Ingress:**
   - Most popular
   - Feature-rich
   - Community-supported

2. **Application Gateway Ingress Controller (AGIC):**
   - Azure-native
   - WAF integration
   - SSL termination

3. **Traefik:**
   - Modern, cloud-native
   - Automatic SSL certificates
   - Dashboard included

**Example:**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
spec:
  ingressClassName: nginx
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-service
            port:
              number: 80
```

**Benefits:**
- Single entry point
- SSL/TLS termination
- Path-based routing
- Host-based routing

---

### 14. What is Service Mesh in AKS?

**Answer:**
Service mesh is a dedicated infrastructure layer for managing service-to-service communication in microservices.

**Popular Options:**
1. **Istio:**
   - Most feature-rich
   - Complex setup
   - Traffic management, security, observability

2. **Linkerd:**
   - Lightweight
   - Easy to use
   - Focus on simplicity

3. **Consul Connect:**
   - HashiCorp product
   - Integrated with Consul
   - Multi-cloud support

**Features:**
- **Traffic Management:** Load balancing, routing, retries
- **Security:** mTLS, authorization policies
- **Observability:** Metrics, tracing, logging
- **Resilience:** Circuit breakers, timeouts

**Use Cases:**
- Complex microservices architectures
- Multi-cloud deployments
- Advanced traffic management
- Security requirements

---

### 15. What is GitOps with AKS?

**Answer:**
GitOps is a methodology for managing Kubernetes deployments using Git as the source of truth.

**Tools:**
1. **Flux:**
   - CNCF project
   - Git-based deployments
   - Multi-tenancy support

2. **ArgoCD:**
   - Popular choice
   - Web UI included
   - Multi-cluster support

**Workflow:**
1. Code changes pushed to Git
2. CI/CD pipeline builds container image
3. GitOps tool detects changes
4. Automatically deploys to AKS
5. Monitors and reconciles state

**Benefits:**
- Version control for infrastructure
- Automated deployments
- Rollback capabilities
- Audit trail
- Collaboration

**Example (Flux):**
```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: app
spec:
  interval: 5m
  path: ./kustomize/app
  prune: true
  sourceRef:
    kind: GitRepository
    name: app-repo
```

---

## Task 22: Service Bus Module ✅

**Status:** ✅ Completed

**Date:** 2026-01-18

### What Was Done:

Created a reusable Terraform module for Azure Service Bus with namespace, queue, and authorization rules:

1. **Directory Structure:**
   ```
   infra/terraform/modules/servicebus/
   ├── main.tf          # Service Bus namespace and queue
   ├── variables.tf     # Module input variables
   ├── outputs.tf       # Module outputs
   └── README.md        # Module documentation
   ```

2. **main.tf Features:**
   - **Service Bus Namespace:**
     - Configurable SKU (Basic, Standard, Premium)
     - Managed identity support (SystemAssigned, UserAssigned)
     - Zone redundancy (Premium SKU)
     - TLS configuration
     - Public network access control
     - Local authentication settings
   
   - **Notification Queue:**
     - Queue name: `notification-queue` (configurable)
     - Message TTL configuration
     - Lock duration settings
     - Dead lettering on expiration
     - Duplicate detection
     - Session support
     - Partitioning (Standard SKU)
     - Auto-delete on idle
     - Forwarding support
   
   - **Authorization Rules:**
     - Namespace-level authorization rule (default: RootManageSharedAccessKey)
     - Queue-level authorization rule (optional)
     - Configurable permissions (Listen, Send, Manage)

3. **variables.tf:**
   - **Required Variables:**
     - `namespace_name` - Service Bus namespace name
     - `location` - Azure region
     - `resource_group_name` - Resource group name
   
   - **Namespace Configuration:**
     - `sku` - SKU tier (Basic, Standard, Premium)
     - `capacity` - Capacity units for Premium (1, 2, 4, 8, 16)
     - `zone_redundant` - Zone redundancy (Premium only)
     - `identity_type` - Managed identity type
     - `local_auth_enabled` - Enable connection strings
     - `minimum_tls_version` - TLS version (1.0, 1.2)
     - `public_network_access_enabled` - Public access control
   
   - **Queue Configuration:**
     - `queue_name` - Queue name (default: "notification-queue")
     - `max_delivery_count` - Max delivery attempts (default: 10)
     - `max_size_in_megabytes` - Queue size limit (default: 1024 MB)
     - `default_message_ttl` - Message time-to-live
     - `lock_duration` - Message lock duration
     - `dead_lettering_on_message_expiration` - Enable dead lettering
     - `enable_partitioning` - Enable partitioning
     - `requires_duplicate_detection` - Enable duplicate detection
     - `requires_session` - Enable sessions
     - `enable_batched_operations` - Enable batching
     - `queue_status` - Queue status (Active, Disabled, etc.)
     - `forward_to` - Forward messages to another queue/topic
     - `auto_delete_on_idle` - Auto-delete on idle
   
   - **Authorization Rule Configuration:**
     - `create_namespace_authorization_rule` - Create namespace rule
     - `namespace_authorization_rule_name` - Namespace rule name
     - `namespace_rule_listen/send/manage` - Namespace permissions
     - `create_queue_authorization_rule` - Create queue rule
     - `queue_authorization_rule_name` - Queue rule name
     - `queue_rule_listen/send/manage` - Queue permissions
   
   - All variables include validation rules

4. **outputs.tf:**
   - **Namespace Information:**
     - `namespace_id` - Namespace ID
     - `namespace_name` - Namespace name
     - `namespace_fqdn` - Namespace FQDN
   
   - **Connection Strings (Sensitive):**
     - `connection_string` - Primary connection string
     - `primary_connection_string` - Primary connection string
     - `secondary_connection_string` - Secondary connection string
     - `primary_key` - Primary shared access key
     - `secondary_key` - Secondary shared access key
   
   - **Queue Information:**
     - `queue_name` - Queue name
     - `queue_id` - Queue ID
     - `queue_connection_string` - Queue connection string (if rule created)
     - `queue_primary_key` - Queue primary key (if rule created)
   
   - **Additional Outputs:**
     - `namespace_identity` - Managed identity details
     - `sku` - Namespace SKU
     - `capacity` - Namespace capacity

5. **README.md:**
   - Comprehensive module documentation
   - Usage examples
   - Input/output reference
   - SKU comparison table
   - Queue configuration details
   - Security best practices
   - Code examples (.NET, Python)
   - Managed identity usage
   - Monitoring and troubleshooting

### Key Features:

- **Flexible SKU:** Supports Basic, Standard, and Premium tiers
- **Managed Identity:** System-assigned managed identity support
- **Security:** TLS configuration, authorization rules, network access control
- **Queue Features:** Dead lettering, duplicate detection, sessions, partitioning
- **Connection Strings:** Both namespace and queue-level connection strings
- **Comprehensive Configuration:** Extensive queue settings for different use cases

### Code Snippets:

**main.tf - Service Bus Namespace:**
```hcl
resource "azurerm_servicebus_namespace" "main" {
  name                = var.namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  capacity            = var.capacity

  zone_redundant = var.sku == "Premium" ? var.zone_redundant : false

  identity {
    type = var.identity_type
  }

  local_auth_enabled              = var.local_auth_enabled
  minimum_tls_version             = var.minimum_tls_version
  public_network_access_enabled  = var.public_network_access_enabled

  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
    }
  )
}
```

**main.tf - Notification Queue:**
```hcl
resource "azurerm_servicebus_queue" "notification_queue" {
  name         = var.queue_name
  namespace_id = azurerm_servicebus_namespace.main.id

  max_delivery_count                  = var.max_delivery_count
  max_size_in_megabytes               = var.max_size_in_megabytes
  default_message_ttl                 = var.default_message_ttl
  lock_duration                       = var.lock_duration
  dead_lettering_on_message_expiration = var.dead_lettering_on_message_expiration
  enable_partitioning                 = var.enable_partitioning
  requires_duplicate_detection        = var.requires_duplicate_detection
  requires_session                    = var.requires_session
  enable_batched_operations           = var.enable_batched_operations
  status                              = var.queue_status
}
```

**outputs.tf - Connection Strings:**
```hcl
output "connection_string" {
  description = "Primary connection string for the Service Bus namespace"
  value       = var.create_namespace_authorization_rule ? azurerm_servicebus_namespace_authorization_rule.namespace_rule[0].primary_connection_string : null
  sensitive   = true
}

output "queue_name" {
  description = "Name of the notification queue"
  value       = azurerm_servicebus_queue.notification_queue.name
}
```

### Usage Example:

```hcl
module "servicebus" {
  source = "./modules/servicebus"

  namespace_name      = "sb-microservices-poc"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.microservices.name

  # Queue configuration
  queue_name = "notification-queue"

  # Namespace settings
  sku                = "Standard"
  local_auth_enabled = true

  # Authorization rule
  create_namespace_authorization_rule = true
  namespace_authorization_rule_name   = "RootManageSharedAccessKey"

  tags = {
    Environment = "dev"
    Project     = "Microservices-POC"
  }
}
```

### Using Connection String in Application:

**Get connection string from Terraform output:**
```bash
terraform output -raw connection_string
```

**Use in .NET application:**
```csharp
using Azure.Messaging.ServiceBus;

var connectionString = "Endpoint=sb://...";
var queueName = "notification-queue";

var client = new ServiceBusClient(connectionString);
var sender = client.CreateSender(queueName);

var message = new ServiceBusMessage("Hello, Service Bus!");
await sender.SendMessageAsync(message);
```

---

## Interview Questions: Azure Service Bus

### 1. What is Azure Service Bus?

**Answer:**
Azure Service Bus is a fully managed enterprise message broker with message queues and publish-subscribe topics. It enables decoupled communication between applications and services.

**Key Features:**
- **Message Queues:** Point-to-point messaging
- **Topics and Subscriptions:** Publish-subscribe pattern
- **Reliability:** At-least-once delivery, dead-letter queues
- **Scalability:** Handles millions of messages
- **Security:** Shared Access Signatures (SAS), managed identity
- **Integration:** Works with Azure services and on-premises systems

**Use Cases:**
- Microservices communication
- Event-driven architectures
- Order processing systems
- Notification systems
- Decoupling applications

---

### 2. What are Service Bus SKUs?

**Answer:**
Service Bus offers three SKU tiers with different capabilities and pricing:

**Basic:**
- **Message Size:** 256 KB
- **Max Connections:** 100
- **Throughput:** Limited
- **Features:** Queues and topics
- **Use Case:** Development, testing, low-volume scenarios

**Standard:**
- **Message Size:** 256 KB
- **Max Connections:** 1,000
- **Throughput:** Higher
- **Features:** Queues, topics, subscriptions, partitioning
- **Use Case:** Production workloads, moderate volume

**Premium:**
- **Message Size:** 1 MB
- **Max Connections:** 1,000 per messaging unit
- **Throughput:** Highest (scales with messaging units)
- **Features:** All Standard features + geo-disaster recovery, availability zones, virtual network integration
- **Use Case:** High-volume, mission-critical applications

**Pricing:**
- Basic: Pay per operation
- Standard: Pay per operation (higher limits)
- Premium: Fixed price per messaging unit

---

### 3. What is a Dead-Letter Queue?

**Answer:**
A dead-letter queue (DLQ) is a sub-queue that stores messages that cannot be processed or delivered successfully.

**When Messages Go to DLQ:**
1. **Max Delivery Count Exceeded:** Message delivery attempts exceed `max_delivery_count`
2. **Message Expiration:** Message TTL expires (if `dead_lettering_on_message_expiration = true`)
3. **Manual Dead-Lettering:** Application explicitly moves message to DLQ

**DLQ Features:**
- Separate queue for failed messages
- Can be accessed independently
- Messages retain original properties
- Can be forwarded to another queue/topic

**Configuration:**
```hcl
dead_lettering_on_message_expiration = true
max_delivery_count = 10
```

**Accessing DLQ:**
```csharp
// .NET example
var receiver = client.CreateReceiver(queueName, new ServiceBusReceiverOptions
{
    SubQueue = SubQueue.DeadLetter
});
```

**Best Practices:**
- Monitor DLQ regularly
- Set up alerts for DLQ messages
- Investigate and fix root causes
- Implement retry logic with exponential backoff

---

### 4. What is Duplicate Detection in Service Bus?

**Answer:**
Duplicate detection automatically identifies and removes duplicate messages within a specified time window.

**How It Works:**
- Service Bus tracks message IDs within the time window
- If a message with the same ID arrives within the window, it's rejected
- Time window is configurable (default: 10 minutes)

**Configuration:**
```hcl
requires_duplicate_detection = true
duplicate_detection_history_time_window = "PT10M"  # 10 minutes
```

**Message ID:**
- Can be set by sender
- If not set, Service Bus generates one
- Must be unique within the time window

**Use Cases:**
- Prevent duplicate processing
- Idempotent operations
- Financial transactions
- Order processing

**Limitations:**
- Only works within the time window
- Requires message ID to be set
- Adds slight overhead

---

### 5. What are Sessions in Service Bus?

**Answer:**
Sessions enable ordered message processing and grouping related messages together.

**Features:**
- **Ordered Processing:** Messages processed in order
- **Message Grouping:** Messages with same session ID grouped together
- **State Management:** Session state can be stored
- **Exclusive Processing:** Only one receiver processes a session at a time

**Configuration:**
```hcl
requires_session = true
```

**Use Cases:**
- Order processing (all items in same order)
- User workflows (all steps for same user)
- Sequential operations
- Stateful processing

**Example:**
```csharp
// Send message with session ID
var message = new ServiceBusMessage("Order item 1")
{
    SessionId = "order-12345"
};
await sender.SendMessageAsync(message);

// Receive messages for specific session
var receiver = await client.AcceptSessionAsync(queueName, "order-12345");
var receivedMessage = await receiver.ReceiveMessageAsync();
```

**Limitations:**
- All messages in queue must have session ID
- Cannot mix session and non-session messages
- Slightly higher latency

---

### 6. What is Partitioning in Service Bus?

**Answer:**
Partitioning distributes messages across multiple message brokers to improve throughput and availability.

**How It Works:**
- Messages distributed across partitions
- Each partition handled by separate broker
- Partition key determines which partition
- Available only in Standard SKU (Premium doesn't need it)

**Configuration:**
```hcl
enable_partitioning = true
```

**Partition Key:**
- Can be set by sender
- If not set, Service Bus assigns randomly
- Messages with same key go to same partition

**Benefits:**
- Higher throughput
- Better availability
- Improved performance

**Limitations:**
- Not available in Premium SKU
- Cannot be disabled after enabling
- Some ordering guarantees may be lost

**Best Practices:**
- Use partitioning for high-throughput scenarios
- Use partition keys for related messages
- Consider Premium SKU for better performance

---

### 7. What are Authorization Rules in Service Bus?

**Answer:**
Authorization rules define who can access Service Bus resources and what operations they can perform.

**Types:**
1. **Namespace-Level Rules:**
   - Apply to entire namespace
   - Access all queues, topics, subscriptions
   - Example: `RootManageSharedAccessKey`

2. **Queue/Topic-Level Rules:**
   - Apply to specific queue or topic
   - More restrictive access
   - Better security

**Permissions:**
- **Listen:** Receive messages
- **Send:** Send messages
- **Manage:** Full control (create, delete, configure)

**Shared Access Signatures (SAS):**
- Primary and secondary keys
- Connection strings include keys
- Can be rotated independently

**Configuration:**
```hcl
resource "azurerm_servicebus_namespace_authorization_rule" "rule" {
  name         = "RootManageSharedAccessKey"
  namespace_id = azurerm_servicebus_namespace.main.id

  listen = true
  send   = true
  manage = true
}
```

**Best Practices:**
- Use least privilege principle
- Use queue-level rules when possible
- Rotate keys regularly
- Use managed identity when possible

---

### 8. What is Managed Identity for Service Bus?

**Answer:**
Managed Identity allows Service Bus to authenticate to Azure services without storing credentials.

**Types:**
1. **System-Assigned:** Created and managed by Azure
2. **User-Assigned:** Created separately and assigned

**Benefits:**
- **No Secrets:** No connection strings or keys to manage
- **Automatic Rotation:** Azure manages credential rotation
- **Secure:** Integrated with Azure AD
- **Simplified:** Easier configuration

**Configuration:**
```hcl
identity {
  type = "SystemAssigned"
}
```

**Using Managed Identity:**
```csharp
// .NET example
var credential = new DefaultAzureCredential();
var client = new ServiceBusClient(
    "sb-namespace.servicebus.windows.net",
    credential
);
```

**Permissions:**
- Grant "Azure Service Bus Data Owner" role
- Or "Azure Service Bus Data Sender/Receiver" for specific operations

**Best Practices:**
- Prefer managed identity over connection strings
- Use system-assigned for simplicity
- Grant minimal required permissions

---

### 9. What is Message TTL in Service Bus?

**Answer:**
TTL (Time-To-Live) is the maximum time a message can exist in the queue before it expires.

**Configuration:**
- **Default:** Maximum TTL (effectively unlimited)
- **Format:** ISO 8601 duration (e.g., `PT1H` for 1 hour, `P1D` for 1 day)
- **Per-Message:** Can override queue default

**Example:**
```hcl
default_message_ttl = "PT1H"  # 1 hour
```

**Message-Level TTL:**
```csharp
var message = new ServiceBusMessage("Hello")
{
    TimeToLive = TimeSpan.FromHours(1)
};
```

**Expired Messages:**
- Automatically removed
- Can be moved to dead-letter queue if configured
- Cannot be received after expiration

**Use Cases:**
- Time-sensitive messages
- Prevent stale messages
- Reduce queue size
- Compliance requirements

---

### 10. What is Lock Duration in Service Bus?

**Answer:**
Lock duration is the time a message is locked for processing after being received.

**How It Works:**
1. Message is received and locked
2. Receiver processes message
3. Must complete before lock expires
4. If not completed, message becomes available again

**Configuration:**
```hcl
lock_duration = "PT1M"  # 1 minute
```

**Default:** 1 minute (60 seconds)

**Renewing Locks:**
```csharp
// .NET example
await receiver.RenewMessageLockAsync(message);
```

**Best Practices:**
- Set lock duration based on processing time
- Renew lock if processing takes longer
- Complete or abandon message before lock expires
- Use auto-complete for quick operations

**Considerations:**
- Too short: Messages may become available before processing completes
- Too long: Other receivers wait longer for messages
- Balance based on workload

---

### 11. What is Message Batching in Service Bus?

**Answer:**
Batching allows sending or receiving multiple messages in a single operation, improving throughput.

**Configuration:**
```hcl
enable_batched_operations = true
```

**Sending Batches:**
```csharp
// .NET example
var messages = new List<ServiceBusMessage>
{
    new ServiceBusMessage("Message 1"),
    new ServiceBusMessage("Message 2"),
    new ServiceBusMessage("Message 3")
};
await sender.SendMessagesAsync(messages);
```

**Receiving Batches:**
```csharp
var messages = await receiver.ReceiveMessagesAsync(maxMessages: 10);
```

**Benefits:**
- Higher throughput
- Reduced network overhead
- Better performance
- Lower costs (fewer operations)

**Limitations:**
- Batch size limits (depends on message size)
- All messages in batch must succeed or fail together
- Some ordering guarantees may be lost

**Best Practices:**
- Enable batching for high-throughput scenarios
- Batch size based on message size
- Handle batch failures appropriately

---

### 12. What is Service Bus Topics and Subscriptions?

**Answer:**
Topics and subscriptions enable publish-subscribe messaging pattern, where one message can be delivered to multiple subscribers.

**Components:**
1. **Topic:** Receives messages from publishers
2. **Subscription:** Receives copies of messages from topic
3. **Filters:** Rules that determine which messages go to subscription

**Use Cases:**
- Broadcasting events
- Multiple consumers for same message
- Event-driven architectures
- Decoupling publishers and subscribers

**Example:**
```hcl
# Topic
resource "azurerm_servicebus_topic" "events" {
  name         = "events"
  namespace_id = azurerm_servicebus_namespace.main.id
}

# Subscription
resource "azurerm_servicebus_subscription" "notifications" {
  name     = "notifications"
  topic_id = azurerm_servicebus_topic.events.id
}
```

**Filters:**
- **SQL Filters:** SQL-like expressions
- **Correlation Filters:** Based on message properties

**Benefits:**
- One-to-many messaging
- Selective message delivery
- Scalable architecture
- Flexible routing

---

### 13. What is Service Bus Forwarding?

**Answer:**
Forwarding automatically moves messages from one queue/topic to another.

**Types:**
1. **Forward To:** Forward all messages to another queue/topic
2. **Forward Dead-Lettered Messages To:** Forward dead-lettered messages

**Configuration:**
```hcl
forward_to = "destination-queue"
forward_dead_lettered_messages_to = "dlq-processing-queue"
```

**Use Cases:**
- Message routing
- Dead-letter processing
- Message aggregation
- Multi-stage processing

**Considerations:**
- Forwarding adds latency
- Messages are consumed from source
- Cannot forward and receive from same queue
- Useful for processing pipelines

---

### 14. What is Auto-Delete on Idle in Service Bus?

**Answer:**
Auto-delete on idle automatically deletes a queue/topic when it's idle (no messages) for a specified duration.

**Configuration:**
```hcl
auto_delete_on_idle = "PT1H"  # Delete after 1 hour of idle
```

**Default:** Maximum duration (effectively disabled)

**Use Cases:**
- Temporary queues
- Development/testing
- Cost optimization
- Cleanup unused resources

**Considerations:**
- Permanent deletion (cannot be recovered)
- Use with caution in production
- Set appropriate duration
- Monitor queue usage

---

### 15. How to Monitor Service Bus?

**Answer:**
Azure provides multiple ways to monitor Service Bus:

**Metrics:**
- **Active Messages:** Current messages in queue
- **Dead-Lettered Messages:** Messages in DLQ
- **Incoming Messages:** Messages sent to queue
- **Outgoing Messages:** Messages received from queue
- **Size:** Current size of queue
- **Server Errors:** Service errors

**Logs:**
- **Operational Logs:** Namespace operations
- **Diagnostic Logs:** Enable in Azure Monitor
- **Application Insights:** Custom telemetry

**Alerts:**
- Message count thresholds
- Dead-letter queue alerts
- Error rate alerts
- Size limits

**Best Practices:**
- Set up alerts for DLQ
- Monitor message counts
- Track error rates
- Monitor queue size
- Use Application Insights for custom metrics

---

## Task 23: Database Modules ✅

**Status:** ✅ Completed

**Date:** 2026-01-18

### What Was Done:

Created a comprehensive Terraform module for Azure databases supporting both SQL Server and PostgreSQL Flexible Server:

1. **Directory Structure:**
   ```
   infra/terraform/modules/databases/
   ├── main.tf          # SQL Server, PostgreSQL, databases, firewall rules
   ├── variables.tf     # Module input variables
   ├── outputs.tf       # Module outputs (connection strings)
   └── README.md        # Module documentation
   ```

2. **main.tf Features:**
   - **SQL Server Support:**
     - Azure SQL Server with configurable version
     - Managed identity support
     - Azure AD authentication
     - TLS configuration
     - Public/private network access
     - Transparent Data Encryption (TDE) support
   
   - **SQL Databases:**
     - ProductService database
     - OrderService database
     - Configurable SKU, size, collation
     - Backup retention policies
     - Long-term retention (optional)
     - Geo-backup support
   
   - **PostgreSQL Flexible Server Support:**
     - PostgreSQL Flexible Server (versions 11-16)
     - Managed identity support
     - Azure AD authentication
     - High availability configuration
     - Maintenance window settings
     - Public/private network access
   
   - **PostgreSQL Databases:**
     - ProductService database
     - OrderService database
     - Configurable charset and collation
   
   - **Firewall Rules:**
     - Allow Azure services (0.0.0.0 to 0.0.0.0)
     - Custom IP range rules (for both SQL and PostgreSQL)
   
   - **Private Endpoints:**
     - SQL Server private endpoint (optional)
     - PostgreSQL uses delegated subnet for private access
     - Private DNS zone integration

3. **variables.tf:**
   - **Database Type Selection:**
     - `database_type` - Choose "sql" or "postgresql"
   
   - **SQL Server Variables:**
     - Server name, version, admin credentials
     - Identity type, Azure AD admin
     - TLS version, network access
     - Connection policy, TDE key
   
   - **SQL Database Variables:**
     - Database names (ProductService, OrderService)
     - SKU, size, collation, license type
     - Backup retention, geo-backup
     - Long-term retention settings
   
   - **PostgreSQL Variables:**
     - Server name, version, admin credentials
     - SKU, storage, backup retention
     - High availability mode
     - Maintenance window
     - Network access, delegated subnet
     - Azure AD authentication
     - Identity configuration
   
   - **Firewall Rules:**
     - Allow Azure services flag
     - Custom firewall rules (map of IP ranges)
   
   - **Private Endpoint:**
     - Enable flag
     - Subnet ID
     - Private DNS zone IDs
   
   - All variables include validation rules

4. **outputs.tf:**
   - **SQL Server Outputs:**
     - Server ID, name, FQDN
     - Database IDs and names
     - Connection strings (sensitive)
   
   - **PostgreSQL Outputs:**
     - Server ID, name, FQDN
     - Database IDs and names
     - Connection strings (sensitive)
   
   - **Generic Outputs:**
     - `product_service_connection_string` - Works for both SQL and PostgreSQL
     - `order_service_connection_string` - Works for both SQL and PostgreSQL
     - Database names
     - Identity information
     - Private endpoint ID

5. **README.md:**
   - Comprehensive module documentation
   - SQL Server and PostgreSQL usage examples
   - Connection string formats
   - Key Vault integration examples
   - Application code examples (.NET)
   - Security best practices
   - Backup and HA configuration
   - Monitoring and troubleshooting

### Key Features:

- **Dual Database Support:** Choose SQL Server or PostgreSQL
- **Two Databases:** ProductService and OrderService databases
- **Firewall Rules:** Allow Azure services and custom IP ranges
- **Private Endpoints:** Optional private endpoint for SQL Server
- **Managed Identity:** System-assigned managed identity support
- **Connection Strings:** Ready-to-use connection strings for applications
- **Security:** TLS, Azure AD, TDE support
- **Backup:** Configurable backup retention and geo-backup

### Code Snippets:

**main.tf - SQL Server and Databases:**
```hcl
resource "azurerm_mssql_server" "sql_server" {
  count                        = var.database_type == "sql" ? 1 : 0
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.sql_server_version
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password

  identity {
    type = var.sql_identity_type
  }

  minimum_tls_version          = var.sql_minimum_tls_version
  public_network_access_enabled = var.sql_public_network_access_enabled
}

resource "azurerm_mssql_database" "product_service_db" {
  count      = var.database_type == "sql" ? 1 : 0
  name       = var.product_service_db_name
  server_id  = azurerm_mssql_server.sql_server[0].id
  sku_name   = var.sql_sku_name
  max_size_gb = var.sql_max_size_gb

  short_term_retention_policy {
    retention_days = var.sql_backup_retention_days
  }
}
```

**main.tf - Firewall Rules:**
```hcl
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  count            = var.database_type == "sql" && var.sql_allow_azure_services ? 1 : 0
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sql_server[0].id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
```

**outputs.tf - Connection Strings:**
```hcl
output "product_service_connection_string" {
  description = "Connection string for ProductService database"
  value = var.database_type == "sql" ? (
    "Server=tcp:${azurerm_mssql_server.sql_server[0].fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.product_service_db[0].name};..."
  ) : (
    "Host=${azurerm_postgresql_flexible_server.postgres_server[0].fqdn};Port=5432;Database=${azurerm_postgresql_flexible_server_database.product_service_db[0].name};..."
  )
  sensitive = true
}
```

### Usage Example:

**SQL Server:**
```hcl
module "databases" {
  source = "./modules/databases"

  database_type      = "sql"
  location           = "eastus"
  resource_group_name = azurerm_resource_group.microservices.name

  sql_server_name    = "sql-microservices-poc"
  sql_admin_login    = "sqladmin"
  sql_admin_password = var.sql_admin_password

  product_service_db_name = "ProductServiceDB"
  order_service_db_name   = "OrderServiceDB"

  sql_allow_azure_services = true
  sql_firewall_rules = {
    "AllowMyIP" = {
      start_ip = "1.2.3.4"
      end_ip   = "1.2.3.4"
    }
  }

  tags = {
    Environment = "dev"
    Project     = "Microservices-POC"
  }
}
```

**PostgreSQL:**
```hcl
module "databases" {
  source = "./modules/databases"

  database_type      = "postgresql"
  location           = "eastus"
  resource_group_name = azurerm_resource_group.microservices.name

  postgres_server_name    = "postgres-microservices-poc"
  postgres_admin_login    = "postgresadmin"
  postgres_admin_password = var.postgres_admin_password

  product_service_db_name = "ProductServiceDB"
  order_service_db_name   = "OrderServiceDB"

  postgres_allow_azure_services = true

  tags = {
    Environment = "dev"
    Project     = "Microservices-POC"
  }
}
```

### Storing Connection Strings in Key Vault:

```hcl
resource "azurerm_key_vault_secret" "product_service_db_connection" {
  name         = "ProductService-DB-ConnectionString"
  value        = module.databases.product_service_connection_string
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "order_service_db_connection" {
  name         = "OrderService-DB-ConnectionString"
  value        = module.databases.order_service_connection_string
  key_vault_id = azurerm_key_vault.main.id
}
```

### Using Connection Strings in Applications:

**Entity Framework Core (.NET):**
```csharp
// SQL Server
services.AddDbContext<ProductDbContext>(options =>
    options.UseSqlServer(connectionString));

// PostgreSQL
services.AddDbContext<ProductDbContext>(options =>
    options.UseNpgsql(connectionString));
```

---

## Interview Questions: Azure Databases (SQL & PostgreSQL)

### 1. What is Azure SQL Database?

**Answer:**
Azure SQL Database is a fully managed relational database service based on SQL Server, providing high availability, scalability, and security without managing infrastructure.

**Key Features:**
- **Fully Managed:** No infrastructure management
- **High Availability:** 99.99% SLA
- **Auto-scaling:** Scale up/down based on demand
- **Security:** Advanced Threat Protection, Always Encrypted
- **Backup:** Automated backups with point-in-time restore
- **Global Distribution:** Geo-replication support

**Service Tiers:**
- **Basic:** Low-cost, low-performance
- **Standard:** General-purpose workloads
- **Premium:** High-performance, mission-critical
- **Business Critical:** Zone-redundant, read replicas
- **Hyperscale:** Auto-scaling, fast backups

**Use Cases:**
- Web applications
- Enterprise applications
- SaaS applications
- Data analytics
- Mobile applications

---

### 2. What is Azure Database for PostgreSQL Flexible Server?

**Answer:**
Azure Database for PostgreSQL Flexible Server is a fully managed PostgreSQL database service with more control and flexibility than the single-server option.

**Key Features:**
- **Flexible Configuration:** More control over server configuration
- **High Availability:** Zone-redundant HA option
- **Maintenance Window:** Choose maintenance time
- **Network Options:** Public or private access
- **Backup:** Automated backups with point-in-time restore
- **Read Replicas:** Multiple read replicas for scaling

**Compute Tiers:**
- **Burstable (B):** Development, testing
- **General Purpose (GP):** Most production workloads
- **Memory Optimized (MO):** Memory-intensive workloads

**Use Cases:**
- Open-source applications
- Linux-based applications
- PostgreSQL-specific features needed
- Cost optimization
- Multi-cloud deployments

---

### 3. What are SQL Database Service Tiers?

**Answer:**
SQL Database offers different service tiers with varying performance, features, and pricing:

**DTU-Based (Legacy):**
- **Basic:** 5 DTUs, 2 GB storage
- **S0-S12:** 10-3000 DTUs, up to 1 TB
- **P1-P15:** 125-4000 DTUs, up to 4 TB

**vCore-Based (Recommended):**
- **General Purpose:** Balanced compute and storage
- **Business Critical:** Zone-redundant, read replicas
- **Hyperscale:** Auto-scaling, fast backups

**Features by Tier:**
- **Basic:** No geo-replication, limited backup retention
- **Standard:** Geo-replication, longer backup retention
- **Premium:** All features, highest performance
- **Business Critical:** Zone-redundant, read replicas
- **Hyperscale:** Auto-scaling, 100 TB storage

**Choosing a Tier:**
- **Basic:** Development, testing
- **Standard:** Small to medium production
- **Premium:** High-performance production
- **Business Critical:** Mission-critical, high availability
- **Hyperscale:** Very large databases, auto-scaling

---

### 4. What is Transparent Data Encryption (TDE)?

**Answer:**
TDE encrypts data at rest in SQL Database, protecting against unauthorized access to database files.

**How It Works:**
- Encrypts data files, log files, backups
- Uses database encryption key (DEK)
- DEK protected by service-managed certificate
- Transparent to applications (no code changes)

**Benefits:**
- **Security:** Data encrypted at rest
- **Compliance:** Meets regulatory requirements
- **Transparent:** No application changes needed
- **Performance:** Minimal performance impact

**Configuration:**
```hcl
transparent_data_encryption_key_vault_key_id = azurerm_key_vault_key.example.id
```

**Best Practices:**
- Enable TDE for all production databases
- Use customer-managed keys for more control
- Store keys in Azure Key Vault
- Rotate keys regularly

---

### 5. What is Azure AD Authentication for SQL Database?

**Answer:**
Azure AD authentication allows connecting to SQL Database using Azure AD identities instead of SQL Server authentication.

**Benefits:**
- **Centralized Identity:** Single identity management
- **No Password Management:** No SQL passwords to manage
- **MFA Support:** Multi-factor authentication
- **Conditional Access:** Azure AD conditional access policies
- **Audit Trail:** Better audit logging

**Configuration:**
```hcl
azuread_administrator {
  login_username = "admin@domain.com"
  object_id      = "object-id"
  tenant_id      = "tenant-id"
}
```

**Using Azure AD:**
```csharp
// .NET example
var connectionString = "Server=...;Database=...;Authentication=Active Directory Default;";
using var connection = new SqlConnection(connectionString);
```

**Best Practices:**
- Use Azure AD for all new applications
- Disable SQL authentication when possible
- Use managed identity for applications
- Grant minimal required permissions

---

### 6. What are Firewall Rules in Azure SQL Database?

**Answer:**
Firewall rules control which IP addresses can connect to SQL Database, providing network-level security.

**Types:**
1. **Server-Level Rules:**
   - Apply to all databases on server
   - Managed via Azure Portal or Terraform
   - Stored in master database

2. **Database-Level Rules:**
   - Apply to specific database
   - More granular control
   - Stored in user database

**Allow Azure Services:**
- Rule: 0.0.0.0 to 0.0.0.0
- Allows all Azure services
- Useful for Azure-hosted applications

**Custom Rules:**
```hcl
sql_firewall_rules = {
  "OfficeIP" = {
    start_ip = "203.0.113.0"
    end_ip   = "203.0.113.255"
  }
}
```

**Best Practices:**
- Use private endpoints for production
- Restrict to specific IP ranges
- Regularly review and update rules
- Use database-level rules when possible
- Monitor failed login attempts

---

### 7. What are Private Endpoints for SQL Database?

**Answer:**
Private endpoints provide private connectivity to SQL Database from within a virtual network, without going through the public internet.

**Benefits:**
- **Security:** No public internet exposure
- **Network Isolation:** Traffic stays within Azure backbone
- **Compliance:** Meets network isolation requirements
- **Performance:** Lower latency, more reliable

**How It Works:**
1. Create private endpoint in VNet
2. Private IP assigned from subnet
3. Private DNS zone resolves to private IP
4. Applications connect via private IP

**Configuration:**
```hcl
resource "azurerm_private_endpoint" "sql_pe" {
  name                = "sql-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.private.id

  private_service_connection {
    name                           = "sql-psc"
    private_connection_resource_id = azurerm_mssql_server.main.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "sql-dns-zone"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql.id]
  }
}
```

**Best Practices:**
- Use private endpoints for production
- Configure private DNS zones
- Disable public network access
- Use network security groups (NSGs)
- Monitor private endpoint connections

---

### 8. What is Geo-Replication in SQL Database?

**Answer:**
Geo-replication creates readable secondary databases in different Azure regions for disaster recovery and read scaling.

**Types:**
1. **Active Geo-Replication:**
   - Up to 4 readable secondaries
   - Asynchronous replication
   - Manual failover

2. **Auto-Failover Groups:**
   - Automatic failover
   - Multiple secondaries
   - Read-write and read-only endpoints

**Benefits:**
- **Disaster Recovery:** Fast recovery from regional outages
- **Read Scaling:** Distribute read workloads
- **Compliance:** Data residency requirements
- **Performance:** Lower latency for global users

**Configuration:**
```hcl
resource "azurerm_mssql_database" "secondary" {
  name                        = "db-secondary"
  server_id                   = azurerm_mssql_server.secondary.id
  create_mode                = "Secondary"
  creation_source_database_id = azurerm_mssql_database.primary.id
}
```

**Use Cases:**
- Multi-region deployments
- Disaster recovery
- Read scaling
- Compliance requirements

---

### 9. What is Backup and Restore in SQL Database?

**Answer:**
Azure SQL Database provides automated backups with point-in-time restore capabilities.

**Backup Types:**
1. **Full Backups:** Weekly
2. **Differential Backups:** Daily
3. **Transaction Log Backups:** Every 5-10 minutes

**Retention:**
- **Basic:** 7 days
- **Standard:** 35 days
- **Premium:** 35 days
- **Long-Term Retention:** Up to 10 years

**Point-in-Time Restore:**
- Restore to any point within retention period
- Creates new database
- Useful for accidental deletions, corruption

**Configuration:**
```hcl
short_term_retention_policy {
  retention_days = 7  # 7-35 days
}

long_term_retention_policy {
  weekly_retention  = "P4W"   # 4 weeks
  monthly_retention = "P12M"  # 12 months
  yearly_retention  = "P7Y"   # 7 years
}
```

**Best Practices:**
- Configure appropriate retention
- Test restore procedures regularly
- Use long-term retention for compliance
- Monitor backup status
- Document restore procedures

---

### 10. What is Connection Pooling in SQL Database?

**Answer:**
Connection pooling reuses database connections instead of creating new ones for each request, improving performance and reducing resource usage.

**Benefits:**
- **Performance:** Faster response times
- **Resource Efficiency:** Fewer connections needed
- **Scalability:** Handle more concurrent requests
- **Cost:** Reduce DTU/vCore usage

**Types:**
1. **Client-Side Pooling:**
   - Managed by application
   - ADO.NET, Entity Framework
   - Connection string parameters

2. **Server-Side Pooling:**
   - Managed by SQL Database
   - Automatic
   - No configuration needed

**Connection String:**
```
Server=...;Database=...;Pooling=true;Min Pool Size=5;Max Pool Size=100;
```

**Best Practices:**
- Enable connection pooling
- Set appropriate pool size
- Close connections properly
- Monitor connection usage
- Use async operations

---

### 11. What is Query Performance Insight?

**Answer:**
Query Performance Insight is an Azure SQL Database feature that provides query performance analytics and recommendations.

**Features:**
- **Query Statistics:** Top resource-consuming queries
- **Duration Trends:** Query execution time over time
- **Wait Statistics:** What queries are waiting for
- **Recommendations:** Index and query optimization suggestions

**Use Cases:**
- Performance troubleshooting
- Query optimization
- Capacity planning
- Cost optimization

**Access:**
- Azure Portal → SQL Database → Query Performance Insight
- Query Store must be enabled
- Historical data available

**Best Practices:**
- Enable Query Store
- Regularly review query performance
- Implement recommendations
- Monitor trends over time
- Use for capacity planning

---

### 12. What is Advanced Threat Protection (ATP)?

**Answer:**
Advanced Threat Protection (now called Microsoft Defender for SQL) detects anomalous activities and potential security threats to SQL Database.

**Threats Detected:**
- SQL injection attacks
- Unusual access patterns
- Brute force attacks
- Privilege escalation
- Data exfiltration

**Features:**
- **Threat Detection:** Real-time threat alerts
- **Vulnerability Assessment:** Database security scanning
- **Security Recommendations:** Best practice suggestions

**Configuration:**
```hcl
# Enable via Azure Portal or separate resource
```

**Alerts:**
- Email notifications
- Azure Security Center integration
- Actionable recommendations

**Best Practices:**
- Enable ATP for all production databases
- Configure email alerts
- Review alerts regularly
- Implement recommendations
- Integrate with Security Center

---

### 13. What is Elastic Pools in SQL Database?

**Answer:**
Elastic pools allow sharing resources (DTUs or vCores) across multiple databases, optimizing cost and performance.

**Benefits:**
- **Cost Optimization:** Pay for shared resources
- **Resource Efficiency:** Databases share resources
- **Simplified Management:** Manage pool instead of individual databases
- **Performance:** Burst capacity when needed

**Use Cases:**
- SaaS applications
- Multiple databases with varying workloads
- Development/test environments
- Cost optimization

**Configuration:**
```hcl
resource "azurerm_mssql_elasticpool" "main" {
  name                = "elastic-pool"
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_mssql_server.main.name
  max_size_gb         = 100

  sku {
    name     = "StandardPool"
    tier     = "Standard"
    capacity = 100  # DTUs
  }

  per_database_settings {
    min_capacity = 0
    max_capacity = 50
  }
}
```

**Best Practices:**
- Use for databases with varying workloads
- Monitor pool utilization
- Set appropriate min/max per database
- Consider auto-scaling
- Review and optimize regularly

---

### 14. What is PostgreSQL Flexible Server vs Single Server?

**Answer:**
Azure offers two PostgreSQL deployment options with different features and management models.

**Flexible Server:**
- **More Control:** Customizable server parameters
- **Better HA:** Zone-redundant high availability
- **Maintenance Window:** Choose maintenance time
- **Network Options:** Public or private access
- **Cost Control:** Stop/start server capability

**Single Server (Legacy):**
- **Simpler:** Less configuration
- **Limited Control:** Fewer customization options
- **Fixed Maintenance:** Azure-managed maintenance
- **Public Access Only:** No private endpoints
- **Being Phased Out:** Not recommended for new deployments

**When to Use Flexible Server:**
- Need more control over configuration
- Require high availability
- Need private network access
- Want to choose maintenance window
- Cost optimization (stop/start)

**Migration:**
- Single Server → Flexible Server migration available
- Plan migration carefully
- Test thoroughly
- Consider downtime

---

### 15. What is High Availability in PostgreSQL Flexible Server?

**Answer:**
PostgreSQL Flexible Server offers high availability options for mission-critical workloads.

**HA Modes:**
1. **Same Zone:**
   - Standby in same availability zone
   - Fast failover
   - Lower cost

2. **Zone Redundant:**
   - Standby in different availability zone
   - Protection against zone failures
   - Higher cost

**How It Works:**
- Primary and standby servers
- Synchronous replication
- Automatic failover
- Minimal data loss

**Configuration:**
```hcl
high_availability {
  mode                      = "ZoneRedundant"
  standby_availability_zone = 2
}
```

**Failover:**
- Automatic failover on primary failure
- Application reconnection required
- DNS update propagates quickly
- Minimal downtime

**Best Practices:**
- Use zone-redundant for production
- Test failover procedures
- Monitor replication lag
- Configure application retry logic
- Document failover procedures

---

## Task 24: Log Analytics & Application Insights Module ✅

**Status:** ✅ Completed

**Date:** 2026-01-18

### What Was Done:

Created a comprehensive Terraform module for Azure monitoring with Log Analytics Workspace and Application Insights:

1. **Directory Structure:**
   ```
   infra/terraform/modules/monitoring/
   ├── main.tf          # Log Analytics Workspace and Application Insights
   ├── variables.tf     # Module input variables
   ├── outputs.tf       # Module outputs (workspace_id, instrumentation_key)
   └── README.md        # Module documentation
   ```

2. **main.tf Features:**
   - **Log Analytics Workspace:**
     - Configurable SKU (PerGB2018, CapacityReservation, Free, etc.)
     - Data retention configuration (30-1095 days)
     - Daily quota limits
     - Internet ingestion and query access control
   
   - **Application Insights - Shared Mode:**
     - Single Application Insights instance for all services
     - Cost-effective for small to medium applications
     - Unified monitoring view
   
   - **Application Insights - Per-Service Mode:**
     - Separate Application Insights instance for each service:
       - ProductService
       - OrderService
       - NotificationService
     - Better isolation and service-specific dashboards
     - Recommended for production microservices
   
   - **Application Insights Configuration:**
     - Application type (web, java, Node.JS, etc.)
     - Data retention (30-730 days)
     - Daily data cap
     - Sampling percentage
     - IP masking control
     - Integration with Log Analytics Workspace

3. **variables.tf:**
   - **Log Analytics Variables:**
     - Workspace name, SKU, retention days
     - Daily quota, internet access settings
   
   - **Application Insights Variables:**
     - Deployment mode (shared or per-service)
     - Application type
     - Retention days, daily data cap
     - Sampling percentage
     - IP masking settings
   
   - **Naming Variables:**
     - Shared Application Insights name
     - Per-service Application Insights names
   
   - All variables include validation rules

4. **outputs.tf:**
   - **Log Analytics Outputs:**
     - `workspace_id` - Workspace ID (primary output)
     - Workspace name, GUID
     - Primary and secondary shared keys (sensitive)
   
   - **Shared Mode Outputs:**
     - `instrumentation_key` - Instrumentation key (sensitive)
     - Connection string (sensitive)
     - App ID
   
   - **Per-Service Mode Outputs:**
     - ProductService instrumentation key and connection string
     - OrderService instrumentation key and connection string
     - NotificationService instrumentation key and connection string
     - `all_instrumentation_keys` - Map of all keys (sensitive)
   
   - **Generic Outputs:**
     - `workspace_id` - Alias for log_analytics_workspace_id
     - `instrumentation_key` - Works for both modes

5. **README.md:**
   - Comprehensive module documentation
   - Shared and per-service mode examples
   - Application integration examples (.NET)
   - Key Vault integration
   - Cost optimization strategies
   - Monitoring features overview
   - AKS integration examples
   - Best practices and troubleshooting

### Key Features:

- **Dual Deployment Modes:** Shared or per-service Application Insights
- **Log Analytics Integration:** Application Insights integrated with Log Analytics
- **Cost Controls:** Daily quotas, data caps, sampling
- **Flexible Configuration:** Retention, SKU, application type
- **Security:** Sensitive outputs marked appropriately
- **Comprehensive Outputs:** All necessary IDs and keys

### Code Snippets:

**main.tf - Log Analytics Workspace:**
```hcl
resource "azurerm_log_analytics_workspace" "main" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.log_analytics_retention_days
  daily_quota_gb      = var.log_analytics_daily_quota_gb
  internet_ingestion_enabled = var.log_analytics_internet_ingestion_enabled
  internet_query_enabled     = var.log_analytics_internet_query_enabled
}
```

**main.tf - Shared Application Insights:**
```hcl
resource "azurerm_application_insights" "shared" {
  count               = var.application_insights_mode == "shared" ? 1 : 0
  name                = var.shared_application_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = var.application_insights_type
  workspace_id        = azurerm_log_analytics_workspace.main.id
  retention_in_days   = var.application_insights_retention_days
  daily_data_cap_in_gb = var.application_insights_daily_data_cap_gb
  sampling_percentage  = var.application_insights_sampling_percentage
}
```

**outputs.tf - Key Outputs:**
```hcl
output "workspace_id" {
  description = "Workspace ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.id
}

output "instrumentation_key" {
  description = "Instrumentation key (shared or ProductService, depending on mode)"
  value = var.application_insights_mode == "shared" ? (
    azurerm_application_insights.shared[0].instrumentation_key
  ) : (
    azurerm_application_insights.product_service[0].instrumentation_key
  )
  sensitive = true
}
```

### Usage Example:

**Shared Mode:**
```hcl
module "monitoring" {
  source = "./modules/monitoring"

  location            = "eastus"
  resource_group_name = azurerm_resource_group.microservices.name

  log_analytics_workspace_name = "law-microservices-poc"
  log_analytics_retention_days = 30

  application_insights_mode = "shared"
  shared_application_insights_name = "appi-microservices-poc"
  application_insights_retention_days = 90

  tags = {
    Environment = "dev"
    Project     = "Microservices-POC"
  }
}
```

**Per-Service Mode:**
```hcl
module "monitoring" {
  source = "./modules/monitoring"

  location            = "eastus"
  resource_group_name = azurerm_resource_group.microservices.name

  log_analytics_workspace_name = "law-microservices-poc"
  log_analytics_retention_days = 30

  application_insights_mode = "per-service"
  product_service_application_insights_name     = "appi-productservice-poc"
  order_service_application_insights_name      = "appi-orderservice-poc"
  notification_service_application_insights_name = "appi-notificationservice-poc"
  application_insights_retention_days = 90

  tags = {
    Environment = "dev"
    Project     = "Microservices-POC"
  }
}
```

### Using in Applications:

**Get outputs:**
```bash
# Workspace ID
terraform output workspace_id

# Instrumentation key (shared mode)
terraform output -raw instrumentation_key

# Instrumentation key (per-service mode)
terraform output -raw product_service_instrumentation_key
```

**Store in Key Vault:**
```hcl
resource "azurerm_key_vault_secret" "app_insights_key" {
  name         = "ApplicationInsights-InstrumentationKey"
  value        = module.monitoring.instrumentation_key
  key_vault_id = azurerm_key_vault.main.id
}
```

**Use in .NET Application:**
```csharp
// appsettings.json
{
  "ApplicationInsights": {
    "ConnectionString": "your-connection-string"
  }
}

// Program.cs
builder.Services.AddApplicationInsightsTelemetry();
```

---

## Interview Questions: Azure Monitor & Application Insights

### 1. What is Azure Monitor?

**Answer:**
Azure Monitor is a comprehensive monitoring and observability platform for Azure resources and applications, providing metrics, logs, and insights.

**Key Components:**
- **Metrics:** Time-series data (CPU, memory, requests)
- **Logs:** Text-based data (application logs, events)
- **Traces:** Distributed tracing across services
- **Alerts:** Notifications based on conditions
- **Workbooks:** Interactive dashboards
- **Insights:** Pre-built monitoring experiences

**Services:**
- **Application Insights:** Application performance monitoring (APM)
- **Log Analytics:** Centralized log collection and analysis
- **Container Insights:** Kubernetes and container monitoring
- **VM Insights:** Virtual machine monitoring

**Use Cases:**
- Application performance monitoring
- Infrastructure monitoring
- Security monitoring
- Cost analysis
- Troubleshooting and diagnostics

---

### 2. What is Application Insights?

**Answer:**
Application Insights is an Application Performance Management (APM) service that monitors live applications, providing insights into performance, availability, and usage.

**Key Features:**
- **Performance Monitoring:** Response times, throughput, dependencies
- **Availability Monitoring:** Uptime monitoring, web tests
- **Exception Tracking:** Unhandled exceptions and errors
- **Custom Metrics:** Application-specific metrics
- **Live Metrics:** Real-time telemetry streaming
- **Smart Detection:** AI-powered anomaly detection
- **Application Map:** Visual dependency map
- **User Analytics:** User behavior and usage patterns

**Supported Platforms:**
- .NET (ASP.NET, ASP.NET Core)
- Java
- Node.js
- Python
- PHP
- Ruby
- Go
- Mobile (iOS, Android)

**Data Collected:**
- Requests and responses
- Dependencies (database, HTTP calls)
- Exceptions
- Performance counters
- Custom events and metrics
- Traces and logs

---

### 3. What is Log Analytics Workspace?

**Answer:**
Log Analytics Workspace is a centralized repository for log data from Azure resources, on-premises resources, and applications.

**Features:**
- **Log Collection:** Collect logs from multiple sources
- **Query Language:** KQL (Kusto Query Language)
- **Data Retention:** 30-1095 days
- **Solutions:** Pre-built monitoring solutions
- **Workbooks:** Interactive dashboards
- **Alerts:** Log-based alerts
- **Data Export:** Export to storage accounts

**Data Sources:**
- Azure resources (VMs, AKS, databases)
- Applications (Application Insights)
- On-premises servers
- Custom logs
- Security events

**Use Cases:**
- Centralized log management
- Security and compliance auditing
- Troubleshooting
- Performance analysis
- Cost optimization

**SKU Options:**
- **PerGB2018:** Pay per GB ingested (recommended)
- **CapacityReservation:** Reserved capacity
- **Free:** Limited free tier
- **PerNode:** Per-node pricing
- **Premium:** Premium features

---

### 4. What is the Difference Between Instrumentation Key and Connection String?

**Answer:**
Both are used to connect applications to Application Insights, but connection strings are the modern, recommended approach.

**Instrumentation Key:**
- Legacy method (still supported)
- Single key for all telemetry
- Less flexible
- Region-specific
- Format: `GUID`

**Connection String:**
- Modern, recommended method
- More flexible configuration
- Can specify ingestion endpoint
- Can specify live metrics endpoint
- Format: `InstrumentationKey=GUID;IngestionEndpoint=https://...;LiveEndpoint=https://...`

**Migration:**
- Connection strings are backward compatible
- Can use both simultaneously
- Connection string takes precedence
- Recommended to migrate to connection strings

**Example:**
```json
{
  "ApplicationInsights": {
    "ConnectionString": "InstrumentationKey=xxx;IngestionEndpoint=https://..."
  }
}
```

---

### 5. What is Telemetry Sampling in Application Insights?

**Answer:**
Sampling reduces the volume of telemetry sent to Application Insights while maintaining statistical accuracy, helping control costs.

**Types:**
1. **Adaptive Sampling:**
   - Automatic sampling based on volume
   - Default for ASP.NET and ASP.NET Core
   - Adjusts sampling rate dynamically

2. **Fixed-Rate Sampling:**
   - Fixed percentage of telemetry sampled
   - Consistent sampling rate
   - Configurable per telemetry type

3. **Ingestion Sampling:**
   - Sampling at ingestion endpoint
   - Applied after telemetry is sent
   - Less efficient (still counts toward quota)

**Configuration:**
```csharp
// .NET example
services.ConfigureTelemetryModule<AdaptiveSamplingTelemetryProcessor>(
    (module, o) => {
        module.MaxTelemetryItemsPerSecond = 5;
    }
);
```

**Best Practices:**
- Use adaptive sampling for most scenarios
- Set appropriate sampling rates (10-50%)
- Sample exceptions and dependencies at higher rates
- Monitor sampling impact
- Adjust based on costs and needs

---

### 6. What is Application Map in Application Insights?

**Answer:**
Application Map is a visual representation of application dependencies, showing how components interact and their health status.

**Features:**
- **Dependency Visualization:** Shows connections between services
- **Health Indicators:** Color-coded health status
- **Performance Metrics:** Response times, error rates
- **Topology Discovery:** Automatic dependency detection
- **Drill-Down:** Click components for details

**Components Shown:**
- Application services
- External dependencies (databases, APIs)
- Azure services
- Custom components

**Use Cases:**
- Understanding application architecture
- Identifying bottlenecks
- Troubleshooting issues
- Performance optimization
- Documentation

**Requirements:**
- Application Insights SDK installed
- Dependency tracking enabled
- Sufficient telemetry data

---

### 7. What is Smart Detection in Application Insights?

**Answer:**
Smart Detection uses machine learning to automatically detect anomalies and potential issues in applications.

**Detections:**
- **Failure Anomalies:** Unusual failure rate increases
- **Performance Degradation:** Response time increases
- **Dependency Performance:** Slow dependency calls
- **Exception Volume:** Unusual exception spikes
- **Memory Leaks:** Gradual memory consumption increases
- **Slow Page Load:** Page load time increases

**Benefits:**
- **Proactive:** Detects issues before users notice
- **Automatic:** No configuration needed
- **Actionable:** Provides recommendations
- **Contextual:** Includes relevant data

**Configuration:**
- Enabled by default
- Email notifications configurable
- Can disable specific detections
- Custom thresholds available

**Best Practices:**
- Keep Smart Detection enabled
- Configure email notifications
- Review detections regularly
- Act on recommendations
- Use for proactive monitoring

---

### 8. What is Live Metrics in Application Insights?

**Answer:**
Live Metrics provides real-time streaming of application telemetry with sub-second latency, useful for immediate troubleshooting.

**Features:**
- **Real-Time:** Sub-second latency
- **Streaming:** Continuous telemetry stream
- **Filtering:** Filter by server, instance, metric
- **Custom Metrics:** Application-specific metrics
- **Performance Counters:** System metrics

**Use Cases:**
- Immediate troubleshooting
- Deployment validation
- Performance testing
- Real-time monitoring
- Debugging production issues

**Limitations:**
- Not stored (not available in queries)
- Limited retention (few minutes)
- Higher resource usage
- Not suitable for historical analysis

**Access:**
- Azure Portal → Application Insights → Live Metrics
- Requires Application Insights SDK
- May require firewall rules

---

### 9. What is Kusto Query Language (KQL)?

**Answer:**
KQL is the query language used in Log Analytics and Application Insights to search and analyze log data.

**Key Features:**
- **Powerful:** Complex queries and aggregations
- **Fast:** Optimized for large datasets
- **Flexible:** Supports joins, aggregations, time-series
- **IntelliSense:** Auto-completion in Azure Portal

**Common Operations:**
- **Filter:** `where` clause
- **Project:** Select columns
- **Summarize:** Aggregations
- **Join:** Combine tables
- **Time-Series:** Time-based analysis

**Example Queries:**
```kql
// Top 10 requests by count
requests
| summarize count() by name
| top 10 by count_

// Average response time by hour
requests
| summarize avg(duration) by bin(timestamp, 1h)
| render timechart

// Failed requests
requests
| where success == false
| summarize count() by name, resultCode
```

**Use Cases:**
- Log analysis
- Performance analysis
- Troubleshooting
- Security investigation
- Custom dashboards

---

### 10. What is Log Analytics Data Retention?

**Answer:**
Data retention determines how long log data is stored in Log Analytics Workspace before being deleted.

**Retention Options:**
- **30, 31, 60, 90, 120, 180, 270, 365, 550, 730, 1095 days**

**Default:** 30 days

**Cost Impact:**
- Longer retention = higher cost
- Data stored beyond free tier is charged
- Consider compliance requirements

**Configuration:**
```hcl
retention_in_days = 90
```

**Best Practices:**
- Set retention based on compliance needs
- Use shorter retention for development
- Longer retention for production
- Consider data export for long-term storage
- Review and optimize regularly

**Data Export:**
- Export to Storage Account for long-term retention
- Export to Event Hub for streaming
- Automated export available
- Cost-effective for archival

---

### 11. What is Application Insights Daily Data Cap?

**Answer:**
Daily data cap limits the amount of telemetry data ingested per day to control costs.

**Configuration:**
```hcl
daily_data_cap_in_gb = 1  # 1 GB per day
```

**Behavior:**
- When cap is reached, telemetry is throttled
- Alerts sent when cap is reached
- Can be increased or disabled
- Resets daily

**Best Practices:**
- Set appropriate cap based on needs
- Monitor cap usage
- Adjust based on actual usage
- Use sampling to reduce data volume
- Review and optimize regularly

**Considerations:**
- Too low: May lose important telemetry
- Too high: May incur unexpected costs
- Balance between cost and data completeness
- Use with sampling for best results

---

### 12. What is Container Insights?

**Answer:**
Container Insights provides monitoring for Kubernetes clusters and containerized applications running on AKS.

**Features:**
- **Cluster Metrics:** Node and pod metrics
- **Container Metrics:** CPU, memory, network
- **Log Collection:** Container logs
- **Performance Monitoring:** Application performance
- **Health Monitoring:** Cluster and pod health

**Requirements:**
- Log Analytics Workspace
- OMS Agent enabled on AKS
- Appropriate permissions

**Configuration:**
```hcl
# In AKS module
oms_agent {
  enabled                    = true
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
}
```

**Use Cases:**
- Kubernetes cluster monitoring
- Container performance analysis
- Troubleshooting container issues
- Capacity planning
- Cost optimization

**Metrics Collected:**
- Node CPU and memory
- Pod CPU and memory
- Network throughput
- Storage usage
- Application metrics

---

### 13. What is Application Insights Availability Monitoring?

**Answer:**
Availability monitoring tests application endpoints from multiple locations to ensure applications are accessible and performing correctly.

**Test Types:**
1. **URL Ping Test:**
   - Simple HTTP/HTTPS request
   - Checks if endpoint responds
   - Configurable success criteria

2. **Multi-Step Web Test:**
   - Complex test scenarios
   - Multiple steps and validations
   - Can test user workflows

**Features:**
- **Multiple Locations:** Test from various Azure regions
- **Frequency:** Configurable test frequency
- **Alerts:** Notifications on failures
- **Availability Metrics:** Uptime percentage
- **Response Time:** Endpoint response times

**Configuration:**
- Azure Portal → Application Insights → Availability
- Create new test
- Configure URL, locations, frequency
- Set up alerts

**Use Cases:**
- Uptime monitoring
- Performance monitoring
- Geographic availability
- SLA compliance
- Proactive issue detection

---

### 14. What is Application Insights Custom Metrics?

**Answer:**
Custom metrics allow applications to send application-specific metrics to Application Insights for monitoring and alerting.

**Types:**
1. **Custom Metrics API:**
   - Send metrics programmatically
   - Supports numeric values
   - Aggregated automatically

2. **TrackMetric:**
   - Legacy method
   - Still supported
   - Less efficient

**Example (.NET):**
```csharp
var telemetryClient = new TelemetryClient();
telemetryClient.TrackMetric("OrdersProcessed", 100);
telemetryClient.TrackMetric("Revenue", 5000.50);
```

**Use Cases:**
- Business metrics (orders, revenue)
- Application-specific metrics
- Performance indicators
- Custom KPIs
- Alerting on custom thresholds

**Best Practices:**
- Use meaningful metric names
- Set appropriate aggregation
- Avoid high-frequency metrics
- Use dimensions for filtering
- Monitor metric volume

---

### 15. What is the Difference Between Shared and Per-Service Application Insights?

**Answer:**
The choice between shared and per-service Application Insights depends on application architecture and monitoring requirements.

**Shared Application Insights:**
- **Single Instance:** One Application Insights for all services
- **Cost:** Lower cost (one instance)
- **Management:** Simpler management
- **View:** Unified view across services
- **Isolation:** Less isolation between services
- **Use Case:** Small to medium applications, cost-sensitive

**Per-Service Application Insights:**
- **Multiple Instances:** Separate Application Insights per service
- **Cost:** Higher cost (multiple instances)
- **Management:** More management overhead
- **View:** Service-specific dashboards
- **Isolation:** Better isolation and troubleshooting
- **Use Case:** Large applications, microservices, production

**Choosing:**
- **Shared:** Start with shared, migrate if needed
- **Per-Service:** Use for production microservices
- **Hybrid:** Mix of both (some services shared, some separate)
- **Consider:** Cost, complexity, isolation needs

**Best Practices:**
- Start with shared for development
- Use per-service for production microservices
- Consider cost vs. isolation trade-off
- Review and optimize based on needs
- Use consistent naming conventions

---

## Task 25: Terraform Structure & Execution Explanation ✅

**Status:** ✅ Completed

**Date:** 2026-01-18

### What Was Done:

Created comprehensive documentation explaining the complete Terraform structure and execution flow:

1. **TERRAFORM_STRUCTURE.md:**
   - Complete directory structure with explanations
   - File-by-file breakdown of all Terraform files
   - Purpose and contents of each file
   - Module structure and available modules
   - Security best practices
   - Common commands reference

2. **EXECUTION_FLOW.md:**
   - Visual execution flow diagram
   - Step-by-step breakdown of `terraform apply`
   - Detailed explanation of each execution phase
   - Example output and verification steps
   - Common issues and solutions
   - Next steps for module integration

### Key Points Explained:

**Current Terraform Structure:**
```
infra/terraform/
├── main.tf                    # Main configuration (provider, resource group)
├── variables.tf                # Variable definitions with validation
├── outputs.tf                  # Output values
├── terraform.tfvars            # Actual variable values (gitignored)
├── terraform.tfvars.example    # Example template
├── README.md                   # Documentation
├── TERRAFORM_STRUCTURE.md      # Structure explanation
├── EXECUTION_FLOW.md           # Execution flow explanation
└── modules/                     # Reusable modules
    ├── aks/                    # AKS cluster module
    ├── databases/              # Database module
    ├── monitoring/             # Monitoring module
    └── servicebus/             # Service Bus module
```

**What Happens on `terraform apply` (Current State):**

1. **Authentication:** Uses Azure CLI credentials
2. **Read Configuration:** Loads all .tf files and terraform.tfvars
3. **Load State:** Reads terraform.tfstate (if exists)
4. **Create Plan:** Determines what needs to be created
5. **Prompt:** Asks for confirmation
6. **Create Resources:** Creates resource group `rg-dev-microservices-poc`
7. **Save State:** Writes terraform.tfstate
8. **Display Outputs:** Shows resource group information

**Current Resources Created:**
- ✅ Resource Group: `rg-dev-microservices-poc` in `eastus`
- ❌ Nothing else (modules are defined but not called yet)

**Modules Status:**
- ✅ AKS Module: Created, not integrated
- ✅ Databases Module: Created, not integrated
- ✅ Monitoring Module: Created, not integrated
- ✅ Service Bus Module: Created, not integrated

### Important Notes:

1. **State Management:**
   - State stored locally in `terraform.tfstate`
   - Never commit state files to Git
   - Consider remote state for teams

2. **Variable Resolution:**
   - `terraform.tfvars` overrides defaults in `variables.tf`
   - Current values: location=eastus, environment=dev, acr_name=vasanthpocacr

3. **Module Integration:**
   - Modules are ready but not called in `main.tf`
   - Need to add `module` blocks to `main.tf` to use them
   - Run `terraform init` after adding modules

4. **Security:**
   - `terraform.tfvars` is gitignored (contains actual values)
   - State files are gitignored (may contain secrets)
   - Use remote state for production

### Documentation Files Created:

1. **TERRAFORM_STRUCTURE.md:**
   - Complete file structure explanation
   - Purpose of each file
   - Module descriptions
   - Security best practices
   - Common commands

2. **EXECUTION_FLOW.md:**
   - Visual flow diagram
   - Step-by-step execution breakdown
   - Example outputs
   - Verification steps
   - Troubleshooting guide

### Next Steps:

To create full infrastructure:
1. Add module calls to `main.tf`
2. Run `terraform init` (downloads modules)
3. Run `terraform plan` (review changes)
4. Run `terraform apply` (create resources)

---

## Task 26: Terraform Infrastructure Deployment ✅

**Status:** ✅ Completed

**Date:** 2026-01-18

### What Was Done:

Successfully deployed complete Azure infrastructure using Terraform with all modules integrated:

1. **Module Integration:**
   - All modules (AKS, Databases, Monitoring, Service Bus) integrated into `main.tf`
   - Variables properly configured in `terraform.tfvars`
   - Outputs configured for all resources

2. **Resources Successfully Created:**

   **Resource Group:**
   - `rg-microservices-poc` (using existing resource group)

   **SQL Server & Databases:**
   - SQL Server: `sql-dev-microservices-poc` (eastus2)
   - Database: `ProductServiceDB` (Basic SKU, 2GB)
   - Database: `OrderServiceDB` (Basic SKU, 2GB)
   - Firewall Rule: Allow Azure Services

   **AKS Cluster:**
   - Cluster: `aks-microservices-poc` (eastus)
   - System Node Pool: 1 node (Standard_D2s_v3)
   - User Node Pool: 2-3 nodes with autoscaling (Standard_D2s_v3)
   - Azure Monitor integration enabled
   - RBAC enabled with Azure AD

   **Monitoring:**
   - Log Analytics Workspace: `law-dev-microservices-poc`
   - Application Insights: `appi-dev-microservices-poc` (shared mode)

   **Service Bus:**
   - Namespace: `sb-dev-microservices-poc` (Standard SKU)
   - Queue: `notification-queue`

3. **Issues Encountered and Fixed:**

   **Issue 1: AKS Node Taints**
   - **Error:** `The AKS API has removed support for tainting all nodes in the default node pool`
   - **Fix:** Removed `node_taints` from `default_node_pool` block in AKS module
   - **Lesson:** Default node pool cannot have taints in newer AKS API versions

   **Issue 2: SQL Server Provisioning Restriction**
   - **Error:** `Provisioning is restricted in this region. Please choose a different region.`
   - **Fix:** Added `sql_server_location` variable (default: `eastus2`) and deployed SQL Server to `eastus2`
   - **Lesson:** Some Azure regions have provisioning restrictions; use alternative regions

   **Issue 3: Service Bus Authorization Rule Conflict**
   - **Error:** `A resource with the ID ".../authorizationRules/RootManageSharedAccessKey" already exists`
   - **Fix:** Set `create_namespace_authorization_rule = false` in Service Bus module call
   - **Lesson:** Azure automatically creates `RootManageSharedAccessKey`; don't try to create it manually

   **Issue 4: SQL Database Size/Tier Mismatch**
   - **Error:** `The tier 'Basic' does not support the database max size '34359738368'`
   - **Fix:** Changed `sql_max_size_gb` to `2` (GB) for Basic SKU compatibility
   - **Lesson:** Basic SKU has size limitations; use appropriate size for tier

   **Issue 5: AKS VM Size Availability**
   - **Error:** `Standard_B2s` VM size not available in `eastus` for this subscription
   - **Fix:** Changed to `Standard_D2s_v3` which is available in the region
   - **Lesson:** VM sizes vary by region and subscription; check availability before deployment

   **Issue 6: AKS Node Label Prefix**
   - **Error:** `Invalid node label key kubernetes.azure.com/mode. The 'kubernetes.azure.com' prefix is preserved by aks system labels`
   - **Fix:** Removed `node_labels` block with `kubernetes.azure.com` prefix from default node pool
   - **Lesson:** Certain label prefixes are reserved by AKS; use custom prefixes

4. **Configuration Changes Made:**

   **main.tf:**
   - Added module calls for AKS, Databases, Monitoring, and Service Bus
   - Configured `local.common_tags` for consistent tagging
   - Set `sql_server_location` to use `var.sql_server_location`
   - Disabled Service Bus namespace authorization rule creation

   **terraform.tfvars:**
   - Set `resource_group_name = "rg-microservices-poc"` (existing RG)
   - Set `database_type = "sql"` (SQL Server only)
   - Configured SQL admin credentials
   - Set `sql_server_location = "eastus2"`
   - Set `aks_subnet_id = null` (AKS creates own VNet)

   **modules/aks/main.tf:**
   - Removed `node_taints` from default node pool
   - Changed VM sizes to `Standard_D2s_v3`
   - Removed reserved node label prefix

   **modules/databases/main.tf:**
   - Made `long_term_retention_policy` conditional using `dynamic` block
   - Made `azuread_administrator` conditional
   - Set `sql_max_size_gb` to 2 for Basic SKU compatibility

   **modules/servicebus/main.tf:**
   - Made namespace authorization rule creation conditional
   - Updated outputs to handle conditional rule creation

5. **Deployment Outputs:**

   ```bash
   # Resource Information
   resource_group_name = "rg-microservices-poc"
   aks_cluster_name = "aks-microservices-poc"
   aks_cluster_fqdn = "aks-5hezkgn0.hcp.eastus.azmk8s.io"
   acr_login_server = "vasanthpocacr.azurecr.io"

   # Connection Strings (Sensitive)
   product_service_db_connection_string = "Server=tcp:sql-dev-microservices-poc.database.windows.net..."
   order_service_db_connection_string = "Server=tcp:sql-dev-microservices-poc.database.windows.net..."
   service_bus_connection_string = "Endpoint=sb://sb-dev-microservices-poc.servicebus.windows.net/..."

   # Monitoring
   log_analytics_workspace_id = "/subscriptions/.../workspaces/law-dev-microservices-poc"
   application_insights_instrumentation_key = "<sensitive>"
   ```

6. **Verification Steps:**

   ```bash
   # Verify resources in Azure Portal
   # Check resource group: rg-microservices-poc
   # Verify all resources are created and running

   # Get AKS credentials
   az aks get-credentials --resource-group rg-microservices-poc --name aks-microservices-poc

   # Verify AKS cluster
   kubectl get nodes
   kubectl get pods --all-namespaces

   # Test database connectivity (from Azure VM or local machine with firewall access)
   # Test Service Bus connection string
   ```

### Key Learnings:

1. **Region Restrictions:** Always check region availability for resources before deployment
2. **API Changes:** AKS API evolves; stay updated with breaking changes
3. **Auto-Created Resources:** Azure creates some resources automatically; don't duplicate them
4. **SKU Limitations:** Each SKU has specific limitations; verify compatibility
5. **VM Size Availability:** VM sizes vary by region and subscription
6. **Reserved Prefixes:** Cloud providers reserve certain prefixes; use custom prefixes

### Infrastructure Status:

- ✅ **Resource Group:** Created and tagged
- ✅ **SQL Server:** Deployed in eastus2 with two databases
- ✅ **AKS Cluster:** Deployed with system and user node pools
- ✅ **Monitoring:** Log Analytics and Application Insights configured
- ✅ **Service Bus:** Namespace and queue created
- ✅ **All Modules:** Successfully integrated and deployed

### Next Steps:

1. **Connect to AKS:**
   ```bash
   az aks get-credentials --resource-group rg-microservices-poc --name aks-microservices-poc
   ```

2. **Deploy Microservices:**
   - Build Docker images
   - Push to Azure Container Registry
   - Create Kubernetes manifests
   - Deploy to AKS

3. **Configure Application Connections:**
   - Update connection strings in applications
   - Configure Service Bus in NotificationService
   - Set up database connections in ProductService and OrderService

4. **Set Up Monitoring:**
   - Configure Application Insights in applications
   - Set up alerts
   - Create dashboards

5. **Security Hardening:**
   - Enable private endpoints for databases
   - Configure network policies in AKS
   - Set up Key Vault for secrets
   - Enable Advanced Threat Protection

---

## Interview Questions: Terraform Troubleshooting & Deployment

### 1. How do you troubleshoot Terraform errors?

**Answer:**
Terraform troubleshooting involves systematic debugging:

**Common Approaches:**
1. **Read Error Messages:** Terraform provides detailed error messages
2. **Check State:** Use `terraform show` to see current state
3. **Validate Configuration:** Run `terraform validate` to check syntax
4. **Review Plan:** Use `terraform plan` to preview changes
5. **Check Provider Documentation:** Verify resource arguments
6. **Review Logs:** Enable verbose logging with `TF_LOG=DEBUG`

**Example:**
```bash
# Validate configuration
terraform validate

# Check plan
terraform plan -out=tfplan

# Review state
terraform show

# Enable debug logging
export TF_LOG=DEBUG
terraform apply
```

**Common Error Types:**
- **Syntax Errors:** Invalid HCL syntax
- **Provider Errors:** Unsupported arguments or API changes
- **State Errors:** State file corruption or drift
- **Resource Conflicts:** Duplicate resources or naming conflicts
- **Permission Errors:** Insufficient Azure permissions

---

### 2. What is Configuration Drift and how do you handle it?

**Answer:**
Configuration drift occurs when actual infrastructure differs from Terraform state.

**Causes:**
- Manual changes to resources
- External processes modifying infrastructure
- Provider bugs
- State file corruption

**Detection:**
```bash
# Run plan to detect drift
terraform plan

# Refresh state to sync with actual infrastructure
terraform refresh
```

**Resolution:**
1. **Import:** Import manually created resources
2. **Refresh:** Update state to match reality
3. **Recreate:** Destroy and recreate resources
4. **Taint:** Force recreation of specific resources

**Prevention:**
- Never make manual changes
- Use state locking
- Implement access controls
- Regular drift detection

---

### 3. How do you handle Terraform state file conflicts?

**Answer:**
State conflicts occur when multiple users modify infrastructure simultaneously.

**Prevention:**
- **Remote State:** Use Azure Storage backend
- **State Locking:** Automatic with remote backends
- **Workspaces:** Separate state per environment
- **Access Control:** Limit who can run Terraform

**Resolution:**
```bash
# Force unlock (use with caution)
terraform force-unlock <LOCK_ID>

# Refresh state
terraform refresh

# Re-run plan
terraform plan
```

**Best Practices:**
- Always use remote state for teams
- Never disable state locking
- Wait for locks to release naturally
- Use CI/CD for automated deployments

---

### 4. How do you handle provider version conflicts?

**Answer:**
Provider version conflicts occur when Terraform code requires different provider versions.

**Solution:**
```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"  # Allows 3.x, not 4.0
    }
  }
}
```

**Version Constraints:**
- `~> 3.0` - Allow 3.x, not 4.0
- `>= 3.0` - Minimum version
- `= 3.0.0` - Exact version
- `>= 3.0, < 4.0` - Range

**Upgrading:**
```bash
# Update provider
terraform init -upgrade

# Review changes
terraform plan

# Apply if safe
terraform apply
```

---

### 5. How do you debug Terraform module errors?

**Answer:**
Module errors can be complex due to abstraction layers.

**Debugging Steps:**
1. **Check Module Source:** Verify module path or URL
2. **Validate Inputs:** Check variable types and values
3. **Review Module Code:** Inspect module's main.tf
4. **Test Locally:** Test module in isolation
5. **Enable Debug Logging:** Use `TF_LOG=DEBUG`

**Example:**
```bash
# Validate module
terraform validate

# Check module inputs
terraform plan -var-file=terraform.tfvars

# Enable debug logging
export TF_LOG=DEBUG
terraform apply
```

**Common Module Issues:**
- Incorrect variable types
- Missing required variables
- Invalid module source
- Output reference errors
- Dependency issues

---

### 6. How do you handle Azure resource provisioning restrictions?

**Answer:**
Azure may restrict resource provisioning in certain regions or subscriptions.

**Detection:**
- Error: `ProvisioningDisabled: Provisioning is restricted in this region`
- Error: `QuotaExceeded: The subscription quota has been exceeded`

**Solutions:**
1. **Use Alternative Region:**
   ```hcl
   variable "sql_server_location" {
     default = "eastus2"  # Alternative to eastus
   }
   ```

2. **Request Quota Increase:**
   - Azure Portal → Subscriptions → Usage + quotas
   - Request increase for specific resource

3. **Use Different SKU:**
   - Some SKUs may be restricted
   - Use alternative SKU

4. **Check Subscription Limits:**
   - Verify subscription type
   - Check regional availability

**Best Practices:**
- Test in multiple regions
- Have fallback regions configured
- Monitor quota usage
- Request increases proactively

---

### 7. How do you handle Terraform state file corruption?

**Answer:**
State file corruption can occur due to interrupted operations or file system issues.

**Prevention:**
- Use remote state (Azure Storage)
- Enable state locking
- Regular backups
- Version control for state (if safe)

**Recovery:**
```bash
# Backup current state
cp terraform.tfstate terraform.tfstate.backup

# Try to refresh
terraform refresh

# If refresh fails, manually edit state (last resort)
# Or recreate from scratch
terraform import <resource_type>.<name> <resource_id>
```

**Best Practices:**
- Always use remote state
- Regular state backups
- Never edit state manually
- Use `terraform import` for recovery

---

### 8. How do you handle Terraform apply failures mid-execution?

**Answer:**
Apply failures can leave infrastructure in partial state.

**Recovery Steps:**
1. **Review Error:** Understand what failed
2. **Check State:** See what was created
3. **Fix Issue:** Correct configuration or permissions
4. **Re-run Apply:** Terraform is idempotent
5. **Clean Up:** Remove partially created resources if needed

**Example:**
```bash
# Check what was created
terraform show

# Review plan
terraform plan

# Re-run apply (Terraform will fix inconsistencies)
terraform apply

# If needed, target specific resource
terraform apply -target=azurerm_resource_group.example
```

**Best Practices:**
- Use `-target` for specific resources
- Review plan before applying
- Test in non-production first
- Use workspaces for isolation

---

### 9. How do you optimize Terraform execution time?

**Answer:**
Large Terraform configurations can be slow to execute.

**Optimization Strategies:**
1. **Parallel Execution:** Terraform runs operations in parallel
2. **Targeted Operations:** Use `-target` for specific resources
3. **Module Optimization:** Break into smaller modules
4. **State Optimization:** Use remote state with fast storage
5. **Dependency Management:** Minimize unnecessary dependencies

**Example:**
```bash
# Target specific resource
terraform apply -target=module.aks

# Parallel operations (automatic)
terraform apply  # Runs independent resources in parallel
```

**Best Practices:**
- Design for parallel execution
- Minimize dependencies
- Use modules for reusability
- Cache provider plugins

---

### 10. How do you handle sensitive data in Terraform?

**Answer:**
Sensitive data (passwords, keys) must be handled securely.

**Methods:**
1. **Variables with `sensitive = true`:**
   ```hcl
   variable "password" {
     type      = string
     sensitive = true
   }
   ```

2. **Environment Variables:**
   ```bash
   export TF_VAR_password="secret"
   ```

3. **Azure Key Vault:**
   ```hcl
   data "azurerm_key_vault_secret" "password" {
     name         = "db-password"
     key_vault_id = azurerm_key_vault.main.id
   }
   ```

4. **Terraform Cloud/Enterprise:** Secure variable storage

**Best Practices:**
- Never commit secrets to Git
- Use Key Vault for production
- Mark outputs as sensitive
- Rotate secrets regularly
- Use managed identities when possible

---

**Last Updated:** 2026-01-18


