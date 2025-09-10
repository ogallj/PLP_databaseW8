# 📦 E-commerce Database (MySQL)

## Overview
This project contains a relational database schema for an **E-commerce Store** built in MySQL.  
It demonstrates how to design a database with proper **normalization, constraints, and relationships**.

The schema includes the following entities:
- **Customers** — store customer details.
- **Categories** — organize products.
- **Products** — items available for purchase.
- **Suppliers** — suppliers providing products.
- **Orders** — customer purchase records.
- **Order Items** — junction table for the many-to-many relationship between `Orders` and `Products`.

## 🎯 Objectives
- Use **Primary Keys** and **Foreign Keys** for data integrity.
- Define **One-to-Many** and **Many-to-Many** relationships.
- Enforce constraints (`NOT NULL`, `UNIQUE`, `CHECK`).
- Provide **sample data** for testing.

## 🗂️ Database Schema

### Tables & Relationships
- **customers (1) → orders (M)**  
- **orders (1) → order_items (M)**  
- **products (M) ↔ order_items (M)** (many-to-many)  
- **categories (1) → products (M)**  
- **suppliers (1) → products (M)**  



