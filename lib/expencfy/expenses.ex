defmodule Expencfy.Expenses do
  @moduledoc """
  The Expenses context.
  """

  import Ecto.Query, warn: false
  alias Expencfy.Repo

  alias Expencfy.Expenses.{Expense, Category}

  @expense_topic "expenses:updates"
  @category_topic "categories:updates"

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Category
    |> order_by(desc: :updated_at)
    |> Repo.all()
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Gets a single category with its associated expenses.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category_with_expenses!(123)
      %Category{expenses: [%Expense{}, ...]}

      iex> get_category_with_expenses!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category_with_expenses!(id) do
    Category
    |> Repo.get!(id)
    |> Repo.preload(:expenses)
  end

  @doc """
  Returns a list of category names and their IDs.
  This is useful for populating a dropdown or select input in a form.
  The returned list will be in the format:
  [
    {category_name, category_id},
    ...
  ]
  """
  def category_names_and_ids do
    Category
    |> select([c], {c.name, c.id})
    |> order_by([c], asc: c.name)
    |> Repo.all()
  end

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, category} = result ->
        broadcast_category_change({:category_created, category})
        result

      error ->
        error
    end
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, category} = result ->
        broadcast_category_change({:category_updated, category})
        result

      error ->
        error
    end
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    case Repo.delete(category) do
      {:ok, category} = result ->
        broadcast_category_change({:category_deleted, category})
        result

      error ->
        error
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  @doc """
  Returns the list of expenses.

  ## Examples

      iex> list_expenses()
      [%Expense{}, ...]

  """
  def list_expenses do
    Expense
    |> order_by(desc: :updated_at)
    |> Repo.all()
  end

  @doc """
  Gets a single expense.

  Raises `Ecto.NoResultsError` if the Expense does not exist.

  ## Examples

      iex> get_expense!(123)
      %Expense{}

      iex> get_expense!(456)
      ** (Ecto.NoResultsError)

  """
  def get_expense!(id), do: Repo.get!(Expense, id)

  @doc """
  Gets a single expense with its associated category.

  Raises `Ecto.NoResultsError` if the Expense does not exist.

  ## Examples

      iex> get_expense_with_category!(123)
      %Expense{category: %Category{}}

      iex> get_expense_with_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_expense_with_category!(id) do
    Expense
    |> Repo.get!(id)
    |> Repo.preload(:category)
  end

  @doc """
  Creates a expense.

  ## Examples

      iex> create_expense(%{field: value})
      {:ok, %Expense{}}

      iex> create_expense(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_expense(attrs) do
    %Expense{}
    |> Expense.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, expense} ->
        expense_with_category = Repo.preload(expense, :category)
        broadcast_expense_change({:expense_created, expense_with_category})
        {:ok, expense_with_category}

      error ->
        error
    end
  end

  @doc """
  Updates a expense.

  ## Examples

      iex> update_expense(expense, %{field: new_value})
      {:ok, %Expense{}}

      iex> update_expense(expense, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_expense(%Expense{} = expense, attrs) do
    expense
    |> Expense.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, expense} ->
        expense_with_category = Repo.preload(expense, :category)
        broadcast_expense_change({:expense_updated, expense_with_category})
        {:ok, expense_with_category}

      error ->
        error
    end
  end

  @doc """
  Deletes a expense.

  ## Examples

      iex> delete_expense(expense)
      {:ok, %Expense{}}

      iex> delete_expense(expense)
      {:error, %Ecto.Changeset{}}

  """
  def delete_expense(%Expense{} = expense) do
    case Repo.delete(expense) do
      {:ok, expense} = result ->
        broadcast_expense_change({:expense_deleted, expense})
        result

      error ->
        error
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking expense changes.

  ## Examples

      iex> change_expense(expense)
      %Ecto.Changeset{data: %Expense{}}

  """
  def change_expense(%Expense{} = expense, attrs \\ %{}) do
    Expense.changeset(expense, attrs)
  end

  # PubSub functions

  @doc """
  Subscribes to expense updates.

  ## Examples

      iex> Expenses.subscribe()
      :ok
  """
  def subscribe do
    Phoenix.PubSub.subscribe(Expencfy.PubSub, @expense_topic)
  end

  @doc """
  Subscribes to category updates.

  ## Examples

      iex> Expenses.subscribe_to_categories()
      :ok
  """
  def subscribe_to_categories do
    Phoenix.PubSub.subscribe(Expencfy.PubSub, @category_topic)
  end

  defp broadcast_expense_change(message) do
    Phoenix.PubSub.broadcast(Expencfy.PubSub, @expense_topic, message)
  end

  defp broadcast_category_change(message) do
    Phoenix.PubSub.broadcast(Expencfy.PubSub, @category_topic, message)
  end
end
