#!/bin/bash

# DevMethod: Agent Stack Investigation Script
# Genera conocimiento específico del stack para cada agente

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
AGENT_TYPE="$1"
STACK_TECH="$2"
PROJECT_DIR="${3:-.}"
OUTPUT_DIR="$PROJECT_DIR/agent-knowledge"

show_help() {
    echo "DevMethod Agent Stack Investigation"
    echo ""
    echo "Usage: $0 <agent_type> <stack_tech> [project_dir]"
    echo ""
    echo "Agent Types:"
    echo "  dev        - Developer agent investigation"
    echo "  architect  - Architecture agent investigation"  
    echo "  qa         - QA agent investigation"
    echo "  pm         - Product Manager investigation"
    echo ""
    echo "Stack Tech:"
    echo "  nextjs     - Next.js specific patterns"
    echo "  react      - React patterns and best practices"
    echo "  nodejs     - Node.js backend patterns"
    echo "  python     - Python/Django/FastAPI patterns"
    echo "  java       - Java/Spring patterns"
    echo ""
    echo "Examples:"
    echo "  $0 dev nextjs"
    echo "  $0 architect nodejs"
    echo "  $0 qa react ./my-project"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

create_dev_investigation() {
    local tech="$1"
    local output_file="$OUTPUT_DIR/dev-${tech}-knowledge.md"
    
    log_info "Creating dev investigation for $tech..."
    
    case $tech in
        "nextjs")
            cat > "$output_file" << 'EOF'
# DEV Agent Knowledge: Next.js 15

## 🎯 Your Role
You implement features using Next.js 15 App Router, TypeScript, and modern React patterns.

## ✅ ALWAYS DO
- Use App Router (app/ directory)
- Create Server Components by default
- Use TypeScript with strict mode
- Implement error boundaries
- Add loading.tsx for async operations
- Use proper metadata API

## ❌ NEVER DO
- Use Pages Router (pages/ directory)  
- Create Client Components unnecessarily
- Use 'any' type in TypeScript
- Hardcode API URLs
- Skip error handling

## 🔧 Code Patterns

### File Structure Pattern
```
app/
├── page.tsx          # Server Component (default)
├── layout.tsx        # Layout with metadata
├── loading.tsx       # Loading UI
├── error.tsx         # Error boundary
└── components/
    ├── client-comp.tsx    # 'use client' when needed
    └── server-comp.tsx    # Server component
```

### API Route Pattern
```typescript
// app/api/products/route.ts
import { NextRequest, NextResponse } from 'next/server'

export async function GET(request: NextRequest) {
  try {
    const data = await fetchProducts()
    return NextResponse.json(data)
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to fetch products' },
      { status: 500 }
    )
  }
}
```

### Server Component Pattern
```typescript
// app/products/page.tsx
import { Suspense } from 'react'
import ProductList from './components/ProductList'

export default function ProductsPage() {
  return (
    <div>
      <h1>Products</h1>
      <Suspense fallback={<div>Loading products...</div>}>
        <ProductList />
      </Suspense>
    </div>
  )
}
```

### Client Component Pattern (only when needed)
```typescript
// components/InteractiveButton.tsx
'use client'

import { useState } from 'react'

export default function InteractiveButton() {
  const [clicked, setClicked] = useState(false)
  
  return (
    <button onClick={() => setClicked(!clicked)}>
      {clicked ? 'Clicked!' : 'Click me'}
    </button>
  )
}
```

## 🧪 Testing Patterns

### Component Test
```typescript
// __tests__/ProductCard.test.tsx
import { render, screen } from '@testing-library/react'
import ProductCard from '../components/ProductCard'

describe('ProductCard', () => {
  it('displays product name', () => {
    render(<ProductCard name="Test Product" price={10} />)
    expect(screen.getByText('Test Product')).toBeInTheDocument()
  })
})
```

## 📊 Performance Best Practices
- Use next/image for all images
- Implement proper loading states
- Use Suspense for data fetching
- Minimize Client Components
- Use next/font for font optimization

## 🔍 Validation Checklist
Before completing any feature:
- [ ] TypeScript compiles without errors
- [ ] No 'any' types used
- [ ] Server/Client components correctly chosen
- [ ] Error handling implemented
- [ ] Loading states added
- [ ] Tests written and passing
- [ ] Performance considerations addressed
EOF
            ;;
        "react")
            cat > "$output_file" << 'EOF'
# DEV Agent Knowledge: React 18/19

## 🎯 Your Role
You implement React components with modern patterns, hooks, and best practices.

## ✅ ALWAYS DO
- Use functional components with hooks
- Implement proper error boundaries
- Use React.memo for performance optimization
- Handle loading and error states
- Use TypeScript with proper types

## ❌ NEVER DO
- Use class components (unless absolutely necessary)
- Mutate state directly
- Use any type in TypeScript
- Create massive components (>200 lines)
- Skip key props in lists

## 🔧 Code Patterns

### Component Structure
```typescript
// components/ProductCard.tsx
import React from 'react'

interface ProductCardProps {
  id: string
  name: string
  price: number
  onSelect?: (id: string) => void
}

export default function ProductCard({ id, name, price, onSelect }: ProductCardProps) {
  return (
    <div className="product-card">
      <h3>{name}</h3>
      <p>${price}</p>
      {onSelect && (
        <button onClick={() => onSelect(id)}>
          Select
        </button>
      )}
    </div>
  )
}
```

### Custom Hook Pattern
```typescript
// hooks/useProducts.ts
import { useState, useEffect } from 'react'

interface Product {
  id: string
  name: string
  price: number
}

export function useProducts() {
  const [products, setProducts] = useState<Product[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    fetchProducts()
      .then(setProducts)
      .catch(err => setError(err.message))
      .finally(() => setLoading(false))
  }, [])

  return { products, loading, error }
}
```

## 🧪 Testing Patterns

### Component Test
```typescript
import { render, screen, fireEvent } from '@testing-library/react'
import ProductCard from '../ProductCard'

describe('ProductCard', () => {
  it('calls onSelect when button clicked', () => {
    const mockSelect = jest.fn()
    render(<ProductCard id="1" name="Test" price={10} onSelect={mockSelect} />)
    
    fireEvent.click(screen.getByText('Select'))
    expect(mockSelect).toHaveBeenCalledWith('1')
  })
})
```

## 🔍 Validation Checklist
- [ ] PropTypes or TypeScript interfaces defined
- [ ] Error boundaries implemented
- [ ] Loading states handled
- [ ] Accessibility attributes added
- [ ] Performance optimizations applied
- [ ] Tests covering main functionality
EOF
            ;;
        "nodejs")
            cat > "$output_file" << 'EOF'
# DEV Agent Knowledge: Node.js Backend

## 🎯 Your Role
You implement backend APIs, database operations, and server-side logic.

## ✅ ALWAYS DO
- Use async/await for asynchronous operations
- Implement proper error handling
- Validate all input data
- Use environment variables for configuration
- Implement proper logging

## ❌ NEVER DO
- Use synchronous file operations in production
- Hardcode configuration values
- Skip input validation
- Ignore errors silently
- Use deprecated Node.js features

## 🔧 Code Patterns

### Express API Route
```typescript
// routes/products.ts
import express from 'express'
import { body, validationResult } from 'express-validator'
import { ProductService } from '../services/ProductService'

const router = express.Router()

router.post('/products', 
  [
    body('name').isLength({ min: 1 }).withMessage('Name is required'),
    body('price').isNumeric().withMessage('Price must be a number')
  ],
  async (req, res) => {
    try {
      const errors = validationResult(req)
      if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() })
      }

      const product = await ProductService.create(req.body)
      res.status(201).json(product)
    } catch (error) {
      console.error('Error creating product:', error)
      res.status(500).json({ error: 'Internal server error' })
    }
  }
)

export default router
```

### Database Service Pattern
```typescript
// services/ProductService.ts
import { prisma } from '../lib/prisma'

export class ProductService {
  static async create(data: { name: string; price: number }) {
    return await prisma.product.create({
      data: {
        name: data.name,
        price: data.price,
        createdAt: new Date()
      }
    })
  }

  static async findById(id: string) {
    const product = await prisma.product.findUnique({
      where: { id }
    })
    
    if (!product) {
      throw new Error(`Product with id ${id} not found`)
    }
    
    return product
  }
}
```

## 🧪 Testing Patterns

### Service Test
```typescript
// __tests__/ProductService.test.ts
import { ProductService } from '../services/ProductService'
import { prisma } from '../lib/prisma'

jest.mock('../lib/prisma', () => ({
  prisma: {
    product: {
      create: jest.fn(),
      findUnique: jest.fn()
    }
  }
}))

describe('ProductService', () => {
  it('creates product successfully', async () => {
    const mockProduct = { id: '1', name: 'Test Product', price: 10 }
    ;(prisma.product.create as jest.Mock).mockResolvedValue(mockProduct)

    const result = await ProductService.create({ name: 'Test Product', price: 10 })
    
    expect(result).toEqual(mockProduct)
    expect(prisma.product.create).toHaveBeenCalledWith({
      data: expect.objectContaining({
        name: 'Test Product',
        price: 10
      })
    })
  })
})
```

## 🔍 Validation Checklist
- [ ] All async operations use async/await
- [ ] Input validation implemented
- [ ] Error handling covers all scenarios
- [ ] Environment variables used for config
- [ ] Logging implemented for debugging
- [ ] Database operations are transactional when needed
- [ ] Tests cover happy path and error cases
EOF
            ;;
    esac
    
    log_success "Dev investigation created: $output_file"
}

create_architect_investigation() {
    local tech="$1"
    local output_file="$OUTPUT_DIR/architect-${tech}-knowledge.md"
    
    log_info "Creating architect investigation for $tech..."
    
    case $tech in
        "nextjs")
            cat > "$output_file" << 'EOF'
# ARCHITECT Agent Knowledge: Next.js Architecture

## 🎯 Your Role
You design the overall architecture for Next.js applications, including deployment, performance, and scalability.

## 🏗️ Architecture Patterns

### Production Deployment Architecture
```
Internet → CDN → Load Balancer → Next.js Apps → Database
                                     ↓
                               Monitoring & Logging
```

### Recommended Stack
- **Frontend**: Next.js 15 + TypeScript + Tailwind CSS
- **Database**: PostgreSQL + Prisma ORM
- **Authentication**: NextAuth.js or Auth0
- **Deployment**: Vercel (recommended) or AWS/Docker
- **Monitoring**: Vercel Analytics + Sentry
- **Testing**: Jest + Playwright

## 🚀 Performance Architecture

### Caching Strategy
```typescript
// next.config.js
module.exports = {
  experimental: {
    staleTimes: {
      dynamic: 30,        // 30 seconds for dynamic pages
      static: 180,        // 3 minutes for static pages  
    },
  },
  images: {
    remotePatterns: [
      { hostname: 'your-cdn.com' }
    ],
  }
}
```

### Database Architecture
- Connection pooling (PgBouncer recommended)
- Read replicas for heavy read workloads
- Database indexing strategy
- Query optimization with Prisma

## 🔒 Security Architecture

### Security Headers
```typescript
// next.config.js
module.exports = {
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Frame-Options',
            value: 'DENY'
          },
          {
            key: 'X-Content-Type-Options', 
            value: 'nosniff'
          },
          {
            key: 'Referrer-Policy',
            value: 'origin-when-cross-origin'
          }
        ]
      }
    ]
  }
}
```

## 📊 Monitoring Architecture

### Observability Stack
- **Metrics**: Vercel Analytics, Custom metrics
- **Logging**: Structured logging with Pino
- **Error Tracking**: Sentry for error monitoring
- **Performance**: Web Vitals monitoring

## 🔍 Decision Framework

### When to use Server vs Client Components
- **Server Components**: Data fetching, static content, SEO-critical pages
- **Client Components**: Interactive elements, real-time updates, browser APIs

### Database Design Decisions
- Use Prisma for type safety and migrations
- Implement soft deletes for critical data
- Design for horizontal scaling from day 1

## ✅ Architecture Validation Checklist
- [ ] Performance budgets defined and monitored
- [ ] Security headers configured
- [ ] Database scaling strategy planned
- [ ] Monitoring and alerting set up
- [ ] Error handling strategy documented
- [ ] Backup and disaster recovery planned
- [ ] CI/CD pipeline configured
- [ ] Load testing performed
EOF
            ;;
    esac
    
    log_success "Architect investigation created: $output_file"
}

create_qa_investigation() {
    local tech="$1"
    local output_file="$OUTPUT_DIR/qa-${tech}-knowledge.md"
    
    log_info "Creating QA investigation for $tech..."
    
    case $tech in
        "nextjs")
            cat > "$output_file" << 'EOF'
# QA Agent Knowledge: Next.js Testing

## 🎯 Your Role
You ensure code quality, implement comprehensive testing, and validate production readiness for Next.js applications.

## 🧪 Testing Strategy

### Testing Pyramid
1. **Unit Tests (70%)**: Components, utilities, API routes
2. **Integration Tests (20%)**: API endpoints, database operations
3. **E2E Tests (10%)**: Critical user journeys

### Testing Stack
- **Unit Testing**: Jest + React Testing Library
- **E2E Testing**: Playwright
- **Visual Testing**: Chromatic (optional)
- **Performance Testing**: Lighthouse CI

## 🔧 Testing Patterns

### Component Testing
```typescript
// __tests__/ProductCard.test.tsx
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import ProductCard from '../components/ProductCard'

describe('ProductCard', () => {
  const mockProduct = {
    id: '1',
    name: 'Test Product',
    price: 99.99,
    image: '/test-image.jpg'
  }

  it('renders product information correctly', () => {
    render(<ProductCard product={mockProduct} />)
    
    expect(screen.getByText('Test Product')).toBeInTheDocument()
    expect(screen.getByText('$99.99')).toBeInTheDocument()
  })

  it('calls onAddToCart when button clicked', async () => {
    const user = userEvent.setup()
    const mockAddToCart = jest.fn()
    
    render(<ProductCard product={mockProduct} onAddToCart={mockAddToCart} />)
    
    await user.click(screen.getByRole('button', { name: /add to cart/i }))
    expect(mockAddToCart).toHaveBeenCalledWith(mockProduct.id)
  })
})
```

### API Route Testing
```typescript
// __tests__/api/products.test.ts
import { GET, POST } from '../../app/api/products/route'
import { NextRequest } from 'next/server'

describe('/api/products', () => {
  it('GET returns products list', async () => {
    const request = new NextRequest('http://localhost:3000/api/products')
    const response = await GET(request)
    const data = await response.json()
    
    expect(response.status).toBe(200)
    expect(Array.isArray(data)).toBe(true)
  })

  it('POST creates new product', async () => {
    const productData = {
      name: 'New Product',
      price: 29.99
    }
    
    const request = new NextRequest('http://localhost:3000/api/products', {
      method: 'POST',
      body: JSON.stringify(productData)
    })
    
    const response = await POST(request)
    const data = await response.json()
    
    expect(response.status).toBe(201)
    expect(data.name).toBe('New Product')
  })
})
```

### E2E Testing
```typescript
// e2e/product-management.spec.ts
import { test, expect } from '@playwright/test'

test.describe('Product Management', () => {
  test('user can create and view product', async ({ page }) => {
    await page.goto('/admin/products')
    
    // Create product
    await page.click('[data-testid="create-product-btn"]')
    await page.fill('[data-testid="product-name"]', 'Test Product')
    await page.fill('[data-testid="product-price"]', '99.99')
    await page.click('[data-testid="save-product-btn"]')
    
    // Verify product appears in list
    await expect(page.locator('[data-testid="product-list"]')).toContainText('Test Product')
    await expect(page.locator('[data-testid="product-price"]')).toContainText('$99.99')
  })
})
```

## 📊 Quality Gates

### Code Quality Metrics
- **Test Coverage**: Minimum 80% for critical paths
- **TypeScript**: Strict mode enabled, no 'any' types
- **ESLint**: All rules pass, no warnings in production
- **Performance**: Lighthouse score >90 for mobile

### Validation Commands
```bash
# Run all quality checks
npm run lint          # ESLint + Prettier
npm run type-check     # TypeScript compilation
npm run test          # Unit tests
npm run test:e2e      # End-to-end tests
npm run build         # Production build validation
```

## 🔍 Review Checklist

### Code Review Checklist
- [ ] All tests pass and have good coverage
- [ ] No TypeScript errors or 'any' types
- [ ] Performance implications considered
- [ ] Security best practices followed
- [ ] Error handling implemented
- [ ] Accessibility guidelines followed
- [ ] Mobile responsiveness verified

### Production Readiness Checklist
- [ ] Environment variables configured
- [ ] Database migrations tested
- [ ] Error monitoring set up
- [ ] Performance monitoring configured
- [ ] Security headers implemented
- [ ] Backup procedures tested
- [ ] Load testing completed
- [ ] Documentation updated

## ⚡ Performance Testing

### Lighthouse CI Configuration
```javascript
// lighthouserc.js
module.exports = {
  ci: {
    collect: {
      url: ['http://localhost:3000'],
      numberOfRuns: 3
    },
    assert: {
      assertions: {
        'categories:performance': ['warn', { minScore: 0.9 }],
        'categories:accessibility': ['error', { minScore: 0.9 }],
        'categories:best-practices': ['error', { minScore: 0.9 }],
        'categories:seo': ['error', { minScore: 0.9 }]
      }
    }
  }
}
```
EOF
            ;;
    esac
    
    log_success "QA investigation created: $output_file"
}

# Main execution
main() {
    if [ $# -lt 2 ]; then
        show_help
        exit 1
    fi

    # Validate agent type
    case $1 in
        dev|architect|qa|pm)
            AGENT_TYPE="$1"
            ;;
        *)
            echo "Error: Unknown agent type '$1'"
            show_help
            exit 1
            ;;
    esac

    # Create output directory
    mkdir -p "$OUTPUT_DIR"

    # Generate investigation based on agent type
    case $AGENT_TYPE in
        dev)
            create_dev_investigation "$STACK_TECH"
            ;;
        architect)
            create_architect_investigation "$STACK_TECH"
            ;;
        qa)
            create_qa_investigation "$STACK_TECH"
            ;;
        pm)
            log_info "PM investigation not yet implemented"
            ;;
    esac

    echo ""
    log_success "Agent investigation complete!"
    echo "Generated knowledge file in: $OUTPUT_DIR/"
    echo ""
    echo "Next steps:"
    echo "1. Review the generated knowledge file"
    echo "2. Customize it for your specific project needs"
    echo "3. Use it to train/brief your AI agent"
    echo "4. Update based on project learnings"
}

main "$@"