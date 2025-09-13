# Expencfy

Expencfy is a Phoenix-based application to manage your expenses and budgets efficiently.

## Getting Started

### Prerequisites
- Have [Docker](https://www.docker.com/) installed on your system.

### Setup Instructions
1. Clone the repository:
   ```bash
   git clone https://github.com/peguimasid/expencfy.git
   cd expencfy
   ```

2. Start the database using Docker:
   ```bash
   docker compose up -d
   ```

3. Install dependencies, set up the database, and seed initial data:
   ```bash
   mix setup
   ```

4. Start the Phoenix server:
   ```bash
   iex -S mix phx.server
   ```

5. Visit the application in your browser at [http://localhost:4000](http://localhost:4000).

### Running Tests
- Run all tests:
  ```bash
  mix test
  ```

- Run tests in watch mode:
  ```bash
  mix test.watch
  ```

## Deployment
For production deployment guidelines, visit the [Phoenix deployment documentation](https://hexdocs.pm/phoenix/deployment.html).

## Learn More
- [Phoenix Framework Official Website](https://www.phoenixframework.org/)
- [Guides](https://hexdocs.pm/phoenix/overview.html)
- [Documentation](https://hexdocs.pm/phoenix)
- [Forum](https://elixirforum.com/c/phoenix-forum)
- [Source Code](https://github.com/phoenixframework/phoenix)
