-- NovaPay Services — PostgreSQL Schema
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  full_name VARCHAR(255) NOT NULL, email VARCHAR(255) UNIQUE NOT NULL,
  username VARCHAR(100) UNIQUE NOT NULL, password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(20) NOT NULL DEFAULT 'customer' CHECK (role IN ('customer','admin')),
  email_verified BOOLEAN DEFAULT false,
  last_login TIMESTAMPTZ, created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE services (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL, slug VARCHAR(255) UNIQUE NOT NULL,
  description TEXT NOT NULL, category VARCHAR(100) NOT NULL,
  price NUMERIC(12,2) NOT NULL, currency VARCHAR(10) DEFAULT 'USD',
  estimated_delivery VARCHAR(100), features JSONB DEFAULT '[]',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(), updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_number VARCHAR(20) UNIQUE NOT NULL,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  service_id UUID NOT NULL REFERENCES services(id) ON DELETE RESTRICT,
  full_name VARCHAR(255) NOT NULL, email VARCHAR(255) NOT NULL,
  requirements TEXT, notes TEXT,
  price NUMERIC(12,2) NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'awaiting_payment'
    CHECK (status IN ('awaiting_payment','payment_detected','confirming','paid','processing','quality_check','completed','cancelled')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(), updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE payments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  cryptocurrency VARCHAR(10) NOT NULL, network VARCHAR(50) NOT NULL,
  fiat_amount NUMERIC(12,2) NOT NULL, crypto_amount NUMERIC(24,8),
  receiving_address VARCHAR(255) NOT NULL, transaction_hash VARCHAR(255),
  status VARCHAR(30) NOT NULL DEFAULT 'awaiting_payment'
    CHECK (status IN ('awaiting_payment','payment_detected','confirming','paid','failed','expired')),
  confirmation_count INTEGER DEFAULT 0, required_confirmations INTEGER DEFAULT 1,
  expires_at TIMESTAMPTZ, paid_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(), updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE transactions (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), payment_id UUID REFERENCES payments(id), order_id UUID NOT NULL REFERENCES orders(id), type VARCHAR(50) NOT NULL, details JSONB DEFAULT '{}', created_at TIMESTAMPTZ NOT NULL DEFAULT NOW());
CREATE TABLE support_tickets (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), user_id UUID NOT NULL REFERENCES users(id), order_id UUID REFERENCES orders(id), subject VARCHAR(255) NOT NULL, status VARCHAR(20) DEFAULT 'open', priority VARCHAR(10) DEFAULT 'normal', created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(), updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW());
CREATE TABLE ticket_replies (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), ticket_id UUID NOT NULL REFERENCES support_tickets(id), user_id UUID REFERENCES users(id), message TEXT NOT NULL, is_staff BOOLEAN DEFAULT false, created_at TIMESTAMPTZ NOT NULL DEFAULT NOW());
CREATE TABLE notifications (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), user_id UUID NOT NULL REFERENCES users(id), type VARCHAR(50) NOT NULL, title VARCHAR(255) NOT NULL, message TEXT, is_read BOOLEAN DEFAULT false, created_at TIMESTAMPTZ NOT NULL DEFAULT NOW());
CREATE TABLE audit_logs (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), user_id UUID REFERENCES users(id), action VARCHAR(255) NOT NULL, details JSONB DEFAULT '{}', created_at TIMESTAMPTZ NOT NULL DEFAULT NOW());

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_payments_order_id ON payments(order_id);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(status);