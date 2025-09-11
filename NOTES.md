# Currency Handling Approach

## Current Implementation

This project uses the [`elixirmoney/money`](https://github.com/elixirmoney/money) library to handle monetary values. It provides precision, type safety, and built-in formatting for different currencies. Currently, it supports single currency storage and operations.

## Extending to Multiple Currencies

To add support for multiple currencies, the database type is updated to store both the monetary value and its associated currency. This can be achieved by creating a composite type in the database, such as:

- `money_with_currency` which includes `amount` and `currency`
- Utilizing `Money.Ecto.Composite.Type` in the schema to handle this composite type seamlessly.

This change allows the application to manage both values and currencies together without needing separate columns, ensuring consistency and simplifying queries. The Money library's existing features make this extension straightforward and efficient.
