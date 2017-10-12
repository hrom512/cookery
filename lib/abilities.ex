alias Cookery.Data.Accounts.User
alias Cookery.Data.Recipes.Recipe

defimpl Canada.Can, for: User do
  # For render not found if resource not exist
  def can?(_, _, nil), do: true

  # Admin can all
  def can?(%User{is_admin: true}, _, _), do: true

  # User can manage its recipes
  def can?(%User{id: user_id}, _, %Recipe{user_id: user_id}), do: true

  # User can manage his profile
  def can?(%User{id: user_id}, _, %User{id: user_id}), do: true

  # User can show any recipes
  def can?(%User{}, :index, Recipe), do: true
  def can?(%User{}, :show, %Recipe{}), do: true

  # User can create recipes
  def can?(%User{}, :new, Recipe), do: true
  def can?(%User{}, :create, Recipe), do: true

  # Deny another actions
  def can?(%User{}, _, _), do: false

  # Raise if not implemented
  def can?(subject, action, resource) do
    raise """
    Unimplemented authorization check for User! To fix see below...

    Please implement `can?` for User in #{__ENV__.file}.

    The function should match:

    subject:  #{inspect subject}

    action:   #{action}

    resource: #{inspect resource}
    """
  end
end
