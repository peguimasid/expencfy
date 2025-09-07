# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Expencfy.Repo.insert!(%Expencfy.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Expencfy.Repo
alias Expencfy.Expenses.{Category, Expense}

# Clear existing data in development
if Mix.env() == :dev do
  Repo.delete_all(Expense)
  Repo.delete_all(Category)
end

food_dining =
  %Category{
    name: "Food & Dining",
    description: "Groceries, restaurants, and food delivery",
    monthly_budget: 80000
  }
  |> Repo.insert!()

transportation =
  %Category{
    name: "Transportation",
    description: "Gas, public transit, rideshare",
    monthly_budget: 30000
  }
  |> Repo.insert!()

entertainment =
  %Category{
    name: "Entertainment",
    description: "Movies, games, subscriptions",
    monthly_budget: 20000
  }
  |> Repo.insert!()

shopping =
  %Category{
    name: "Shopping",
    description: "Clothing, electronics, miscellaneous",
    monthly_budget: 40000
  }
  |> Repo.insert!()

%Expense{
  description: "Grocery shopping",
  amount: 8945,
  date: ~D[2024-01-14],
  notes: "Weekly groceries",
  category: food_dining
}
|> Repo.insert!()

%Expense{
  description: "Gas refill",
  amount: 18950,
  date: ~D[2024-01-12],
  notes: "Full tank",
  category: transportation
}
|> Repo.insert!()

%Expense{
  description: "Movie night",
  amount: 14599,
  date: ~D[2024-01-10],
  notes: "Cinema ticket and snacks",
  category: entertainment
}
|> Repo.insert!()

%Expense{
  description: "Winter jacket",
  amount: 23467,
  date: ~D[2024-01-08],
  notes: "Purchased at mall",
  category: shopping
}
|> Repo.insert!()

%Expense{
  description: "Coffee subscription",
  amount: 1299,
  date: ~D[2024-01-15],
  notes: "Monthly premium blend",
  category: food_dining
}
|> Repo.insert!()

%Expense{
  description: "Uber ride",
  amount: 1250,
  date: ~D[2024-01-13],
  notes: "Airport to downtown",
  category: transportation
}
|> Repo.insert!()

%Expense{
  description: "Netflix subscription",
  amount: 1599,
  date: ~D[2024-01-11],
  notes: "Monthly streaming service",
  category: entertainment
}
|> Repo.insert!()

%Expense{
  description: "New headphones",
  amount: 12999,
  date: ~D[2024-01-09],
  notes: "Noise-cancelling wireless",
  category: shopping
}
|> Repo.insert!()
