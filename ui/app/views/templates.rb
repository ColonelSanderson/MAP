# You define templates with a name, a list of parameters they take, and an ERB
# file.
#
# If param ends with '?' it's allowed to be nil.
#
# If param is wrapped in an array, that's an array of something.  If you don't
# specify it, you get [].
#
# Partials would work the same way--just <%== Templates.emit(:partial_name) %>
#

Templates.define(:hello, [:name, :agencies], "views/hello.erb.html")
Templates.define(:example_partial, [], "views/_partial.erb.html")

Templates.define(:layout, [:title, :template, :template_args, :message?], "views/layout.erb.html")
Templates.define(:login, [:username?], "views/login.erb.html")
Templates.define(:users, [:users], "views/users.erb.html")
Templates.define(:user_new, [:user], "views/user_form.erb.html")
Templates.define(:flash_message, [:message], "views/_message.erb.html")
