# Postman Collection for Infrastructure Azure .NET

This directory contains Postman collections and environment files for testing all microservices endpoints.

## Files

- **Infrastructure-Azure-DotNet.postman_collection.json** - Complete Postman collection with all endpoints
- **Infrastructure-Azure-DotNet.postman_environment.json** - Environment variables for development

## Import Instructions

### Option 1: Import Collection and Environment

1. Open Postman
2. Click **Import** button (top left)
3. Select both JSON files:
   - `Infrastructure-Azure-DotNet.postman_collection.json`
   - `Infrastructure-Azure-DotNet.postman_environment.json`
4. Click **Import**

### Option 2: Import via File Menu

1. File → Import
2. Select the collection file
3. Select the environment file
4. Click **Import**

## Setting Up Environment

1. After importing, select the environment: **Infrastructure Azure .NET - Development**
2. Verify the base URLs are correct:
   - ProductService: `http://localhost:5088`
   - OrderService: `http://localhost:5174`
   - NotificationService: `http://localhost:5129`

## Collection Structure

### ProductService
- **Health**
  - GET `/health` - Health check
- **Products**
  - GET `/api/products` - Get all products
  - GET `/api/products/{id}` - Get product by ID
  - POST `/api/products` - Create product
  - PUT `/api/products/{id}` - Update product
  - DELETE `/api/products/{id}` - Delete product
  - Error test cases included

### OrderService
- **Health**
  - GET `/health` - Health check
- **Orders**
  - GET `/api/orders` - Get all orders
  - GET `/api/orders/{id}` - Get order by ID
  - POST `/api/orders` - Create order
  - PUT `/api/orders/{id}/status` - Update order status
  - Error test cases included

### NotificationService
- **Health**
  - GET `/health` - Health check
- **Notifications**
  - GET `/api/notifications` - Get all notifications
  - GET `/api/notifications/{id}` - Get notification by ID
  - POST `/api/notifications/send` - Send notification (Email/SMS)
  - Error test cases included

## Running the Services

Before testing, make sure all services are running:

```bash
# Terminal 1 - ProductService
cd src/ProductService
dotnet run

# Terminal 2 - OrderService
cd src/OrderService
dotnet run

# Terminal 3 - NotificationService
cd src/NotificationService
dotnet run
```

## Testing Workflow

### 1. Health Checks
Start by testing health endpoints to ensure services are running:
- ProductService → Health → Get Health
- OrderService → Health → Get Health
- NotificationService → Health → Get Health

### 2. ProductService Testing
1. Get All Products
2. Get Product by ID (use ID: 1, 2, or 3)
3. Create Product (new product will be added)
4. Update Product (modify existing product)
5. Delete Product

### 3. OrderService Testing
1. Get All Orders
2. Get Order by ID
3. Create Order (use valid ProductId: 1, 2, or 3)
4. Update Order Status (use: Pending, Processing, Completed, Cancelled)

### 4. NotificationService Testing
1. Get All Notifications
2. Send Email Notification (will take 2-3 seconds)
3. Send SMS Notification (will take 1-2 seconds)
4. Get Notification by ID (use ID from previous requests)

## Example Request Bodies

### Create Product
```json
{
  "name": "Gaming Mouse",
  "price": 49.99,
  "description": "RGB gaming mouse with high DPI",
  "stock": 75
}
```

### Create Order
```json
{
  "productId": 1,
  "quantity": 2,
  "customerEmail": "customer@example.com"
}
```

### Update Order Status
```json
{
  "status": "Processing"
}
```

### Send Email Notification
```json
{
  "type": "Email",
  "recipient": "customer@example.com",
  "message": "Your order has been confirmed. Thank you for your purchase!"
}
```

### Send SMS Notification
```json
{
  "type": "SMS",
  "recipient": "+1234567890",
  "message": "Your order #12345 has been shipped!"
}
```

## Valid Status Values

### Order Status
- `Pending`
- `Processing`
- `Completed`
- `Cancelled`

### Notification Type
- `Email`
- `SMS`

## Error Testing

The collection includes error test cases:
- Invalid IDs (404 Not Found)
- Validation errors (400 Bad Request)
- Invalid status/type values

## Notes

- All services use in-memory storage, so data resets when services restart
- NotificationService simulates delays (Email: 2-3s, SMS: 1-2s)
- OrderService validates product existence (currently checks IDs: 1, 2, 3)
- Update base URLs in environment variables if ports change

## Troubleshooting

### Connection Refused
- Ensure services are running
- Check if ports match environment variables
- Verify firewall settings

### 404 Not Found
- Check if the resource exists (IDs: 1, 2, 3 for products/orders)
- Verify endpoint paths are correct

### Validation Errors
- Check request body format
- Ensure required fields are provided
- Verify data types match (e.g., price is decimal, stock is int)

## Updating Base URLs

If you need to change the base URLs:

1. In Postman, click on **Environments** (left sidebar)
2. Select **Infrastructure Azure .NET - Development**
3. Update the values:
   - `ProductServiceBaseUrl`
   - `OrderServiceBaseUrl`
   - `NotificationServiceBaseUrl`
4. Save the environment

Or create a new environment for different configurations (staging, production, etc.).
