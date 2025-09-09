defmodule Expencfy.ExpensesTest do
  use Expencfy.DataCase

  alias Expencfy.Expenses

  describe "categories" do
    alias Expencfy.Expenses.Category

    import Expencfy.ExpensesFixtures

    @invalid_attrs %{name: nil, description: nil, monthly_budget: nil}

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Expenses.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Expenses.get_category!(category.id) == category
    end

    test "get_category_with_expenses!/1 returns the category with preloaded expenses" do
      category = category_fixture()
      expense = expense_fixture(%{category_id: category.id})
      category_with_expenses = Expenses.get_category_with_expenses!(category.id)
      assert category_with_expenses.id == category.id
      assert category_with_expenses.expenses == [expense]
    end

    test "get_category_with_expenses!/1 raises Ecto.NoResultsError for non-existent id" do
      assert_raise Ecto.NoResultsError, fn -> Expenses.get_category_with_expenses!(999) end
    end

    test "category_names_and_ids/0 returns list of category names and ids" do
      category1 = category_fixture(%{name: "Category A"})
      category2 = category_fixture(%{name: "Category B"})
      names_and_ids = Expenses.category_names_and_ids()
      assert {"Category A", category1.id} in names_and_ids
      assert {"Category B", category2.id} in names_and_ids
      assert length(names_and_ids) == 2
    end

    test "category_names_and_ids/0 returns categories ordered by name" do
      category1 = category_fixture(%{name: "Z Category"})
      category2 = category_fixture(%{name: "A Category"})

      names_and_ids = Expenses.category_names_and_ids()
      assert [{"A Category", category2.id}, {"Z Category", category1.id}] == names_and_ids
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{name: "some name", description: "some description", monthly_budget: 42}

      assert {:ok, %Category{} = category} = Expenses.create_category(valid_attrs)
      assert category.name == "some name"
      assert category.description == "some description"
      assert category.monthly_budget == %Money{currency: :USD, amount: 42}
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Expenses.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        monthly_budget: 43
      }

      assert {:ok, %Category{} = category} = Expenses.update_category(category, update_attrs)
      assert category.name == "some updated name"
      assert category.description == "some updated description"
      assert category.monthly_budget == %Money{currency: :USD, amount: 43}
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Expenses.update_category(category, @invalid_attrs)
      assert category == Expenses.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Expenses.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Expenses.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Expenses.change_category(category)
    end

    test "change_category/2 returns a category changeset with given attributes" do
      category = category_fixture()
      attrs = %{name: "new name"}
      changeset = Expenses.change_category(category, attrs)
      assert %Ecto.Changeset{} = changeset
      assert changeset.changes.name == "new name"
    end
  end

  describe "expenses" do
    alias Expencfy.Expenses.Expense

    import Expencfy.ExpensesFixtures

    @invalid_attrs %{date: nil, description: nil, amount: nil, notes: nil}

    test "list_expenses/0 returns all expenses" do
      expense = expense_fixture()
      assert Expenses.list_expenses() == [expense]
    end

    test "list_expenses_for_category/1 returns expenses for given category" do
      category1 = category_fixture()
      category2 = category_fixture()
      expense1 = expense_fixture(%{category_id: category1.id})
      expense2 = expense_fixture(%{category_id: category2.id})

      expenses = Expenses.list_expenses_for_category(category1.id)
      assert expenses == [expense1]
      refute expense2 in expenses
    end

    test "list_expenses_for_category/1 returns empty list for non-existent category" do
      assert Expenses.list_expenses_for_category(999) == []
    end

    test "get_expense!/1 returns the expense with given id" do
      expense = expense_fixture()
      assert Expenses.get_expense!(expense.id) == expense
    end

    test "get_expense_with_category!/1 returns the expense with preloaded category" do
      category = category_fixture()
      expense = expense_fixture(%{category_id: category.id})
      expense_with_category = Expenses.get_expense_with_category!(expense.id)
      assert expense_with_category.id == expense.id
      assert expense_with_category.category == category
    end

    test "get_expense_with_category!/1 raises Ecto.NoResultsError for non-existent id" do
      assert_raise Ecto.NoResultsError, fn -> Expenses.get_expense_with_category!(999) end
    end

    test "create_expense/1 with valid data creates a expense" do
      category = category_fixture()

      valid_attrs = %{
        date: ~D[2025-09-06],
        description: "some description",
        amount: 42,
        notes: "some notes",
        category_id: category.id
      }

      assert {:ok, %Expense{} = expense} = Expenses.create_expense(valid_attrs)
      assert expense.date == ~D[2025-09-06]
      assert expense.description == "some description"
      assert expense.amount == %Money{currency: :USD, amount: 42}
      assert expense.notes == "some notes"
    end

    test "create_expense/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Expenses.create_expense(@invalid_attrs)
    end

    test "update_expense/2 with valid data updates the expense" do
      expense = expense_fixture()

      update_attrs = %{
        date: ~D[2025-09-07],
        description: "some updated description",
        amount: 43,
        notes: "some updated notes"
      }

      assert {:ok, %Expense{} = expense} = Expenses.update_expense(expense, update_attrs)
      assert expense.date == ~D[2025-09-07]
      assert expense.description == "some updated description"
      assert expense.amount == %Money{currency: :USD, amount: 43}
      assert expense.notes == "some updated notes"
    end

    test "update_expense/2 with invalid data returns error changeset" do
      expense = expense_fixture()
      assert {:error, %Ecto.Changeset{}} = Expenses.update_expense(expense, @invalid_attrs)
      assert expense == Expenses.get_expense!(expense.id)
    end

    test "delete_expense/1 deletes the expense" do
      expense = expense_fixture()
      assert {:ok, %Expense{}} = Expenses.delete_expense(expense)
      assert_raise Ecto.NoResultsError, fn -> Expenses.get_expense!(expense.id) end
    end

    test "change_expense/1 returns a expense changeset" do
      expense = expense_fixture()
      assert %Ecto.Changeset{} = Expenses.change_expense(expense)
    end

    test "change_expense/2 returns a expense changeset with given attributes" do
      expense = expense_fixture()
      attrs = %{description: "new description"}
      changeset = Expenses.change_expense(expense, attrs)
      assert %Ecto.Changeset{} = changeset
      assert changeset.changes.description == "new description"
    end
  end

  describe "pubsub" do
    import Expencfy.ExpensesFixtures

    test "subscribe/0 subscribes to expense updates" do
      assert :ok = Expenses.subscribe()
    end

    test "subscribe_to_categories/0 subscribes to category updates" do
      assert :ok = Expenses.subscribe_to_categories()
    end

    test "create_category/1 broadcasts category_created message" do
      Expenses.subscribe_to_categories()

      valid_attrs = %{name: "Test Category", description: "Test", monthly_budget: 100}
      {:ok, category} = Expenses.create_category(valid_attrs)

      assert_receive {:category_created, ^category}
    end

    test "update_category/2 broadcasts category_updated message" do
      Expenses.subscribe_to_categories()

      category = category_fixture()
      {:ok, updated_category} = Expenses.update_category(category, %{name: "Updated"})

      assert_receive {:category_updated, ^updated_category}
    end

    test "delete_category/1 broadcasts category_deleted message" do
      Expenses.subscribe_to_categories()

      category = category_fixture()
      {:ok, deleted_category} = Expenses.delete_category(category)

      assert_receive {:category_deleted, ^deleted_category}
    end

    test "create_expense/1 broadcasts expense_created message" do
      Expenses.subscribe()

      category = category_fixture()

      valid_attrs = %{
        date: ~D[2025-01-01],
        description: "Test Expense",
        amount: 50,
        category_id: category.id
      }

      {:ok, expense} = Expenses.create_expense(valid_attrs)

      assert_receive {:expense_created, ^expense}
    end

    test "update_expense/2 broadcasts expense_updated message with preloaded category" do
      Expenses.subscribe()

      expense = expense_fixture()
      {:ok, updated_expense} = Expenses.update_expense(expense, %{description: "Updated"})

      assert_receive {:expense_updated, ^updated_expense}
      assert updated_expense.category != nil
    end

    test "delete_expense/1 broadcasts expense_deleted message" do
      Expenses.subscribe()

      expense = expense_fixture()
      {:ok, deleted_expense} = Expenses.delete_expense(expense)

      assert_receive {:expense_deleted, ^deleted_expense}
    end
  end
end
