# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
  # fail "Unimplemented"
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  movies = page.body.scan(/#{e1}|#{e2}/)
  movies.uniq!
  idx1 = movies.index(e1)
  idx2 = movies.index(e2)
  expect(idx1).to be < idx2
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  rating_list = rating_list.split(", ")
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.each do |rating|
      r = "ratings_" + rating # the acutal checkbox id
      unless uncheck
        step "I check \"#{r}\""
      else
        step "I uncheck \"#{r}\""
      end
  end
  # fail "Unimplemented"
end

Then /I should see movies with ratings: (.*)/ do |selected|
  selected = selected.split(", ")
  selected_movies = Movie.where(:rating => selected)
  selected_movies.each { |movie| step "I should see \"#{movie.title}\"" }
end

Then /I should not see movies with ratings: (.*)/ do |unselected|
  unselected = unselected.split(", ")
  unselected_movies = Movie.where(:rating => unselected)
  unselected_movies.each { |movie| step "I should not see \"#{movie.title}\"" }
end

Then /I should see all the movies/ do 
  # Make sure that all the movies in the app are visible in the table
  movies = Movie.all
  movies.each { |movie| step "I should see \"#{movie.title}\""}
end
