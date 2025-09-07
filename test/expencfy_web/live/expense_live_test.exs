defmodule ExpencfyWeb.ExpenseLiveTest do
  use ExpencfyWeb.ConnCase

  import Phoenix.LiveViewTest
  import Expencfy.ExpensesFixtures

  @create_attrs %{
    date: "2025-09-06",
    description: "some description",
    amount: 4200,
    notes: "some notes"
  }
  @update_attrs %{
    date: "2025-09-07",
    description: "some updated description",
    amount: 4300,
    notes: "some updated notes"
  }
  @invalid_attrs %{date: nil, description: nil, amount: nil, notes: nil}
  defp create_expense(_) do
    expense = expense_fixture()

    %{expense: expense}
  end

  describe "Index" do
    setup [:create_expense]

    test "lists all expenses", %{conn: conn, expense: expense} do
      {:ok, _index_live, html} = live(conn, ~p"/expenses")

      assert html =~ "Listing Expenses"
      assert html =~ expense.description
    end

    test "saves new expense", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/expenses")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Expense")
               |> render_click()
               |> follow_redirect(conn, ~p"/expenses/new")

      assert render(form_live) =~ "New Expense"

      assert form_live
             |> form("#expense-form", expense: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#expense-form", expense: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/expenses")

      html = render(index_live)
      assert html =~ "Expense created successfully"
      assert html =~ "some description"
    end

    test "updates expense in listing", %{conn: conn, expense: expense} do
      {:ok, index_live, _html} = live(conn, ~p"/expenses")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#expenses-#{expense.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/expenses/#{expense}/edit")

      assert render(form_live) =~ "Edit Expense"

      assert form_live
             |> form("#expense-form", expense: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#expense-form", expense: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/expenses")

      html = render(index_live)
      assert html =~ "Expense updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes expense in listing", %{conn: conn, expense: expense} do
      {:ok, index_live, _html} = live(conn, ~p"/expenses")

      assert index_live |> element("#expenses-#{expense.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#expenses-#{expense.id}")
    end

    test "displays formatted date correctly", %{conn: conn, expense: expense} do
      {:ok, _show_live, html} = live(conn, ~p"/expenses/#{expense}")

      formatted_date = Timex.format!(expense.date, "{0M}/{0D}/{YYYY}")
      assert html =~ formatted_date
    end

    test "displays formatted currency in listing", %{conn: conn, expense: expense} do
      {:ok, _index_live, html} = live(conn, ~p"/expenses")

      expected_amount = Money.to_string(expense.amount)
      assert html =~ expected_amount
    end
  end

  describe "Show" do
    setup [:create_expense]

    test "displays expense", %{conn: conn, expense: expense} do
      {:ok, _show_live, html} = live(conn, ~p"/expenses/#{expense}")

      assert html =~ "Show Expense"
      assert html =~ expense.description
    end

    test "updates expense and returns to show", %{conn: conn, expense: expense} do
      {:ok, show_live, _html} = live(conn, ~p"/expenses/#{expense}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/expenses/#{expense}/edit?return_to=show")

      assert render(form_live) =~ "Edit Expense"

      assert form_live
             |> form("#expense-form", expense: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#expense-form", expense: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/expenses/#{expense}")

      html = render(show_live)
      assert html =~ "Expense updated successfully"
      assert html =~ "some updated description"
    end

    test "displays formatted currency in listing", %{conn: conn, expense: expense} do
      {:ok, _index_live, html} = live(conn, ~p"/expenses")

      expected_amount = Money.to_string(expense.amount)
      assert html =~ expected_amount
    end
  end
end
