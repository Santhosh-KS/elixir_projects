alias Mastery.Core.{Template, Quiz, Response}

generator = %{left: [1,2], right: [1,2]}

checker =  fn (sub, answer) -> 
  sub[:left] + sub[:right] == String.to_integer(answer)
end

quiz = Quiz.new(title: "Addition", mastery: 2) \
 |> Quiz.add_template(
    name: :single_digit_addition,
    category: :addition,
    instructions: "Add the numbers",
    raw: "<%= @left %> + <%= @right %>",
    generators: generator,
    checker: checker
  )  |> Quiz.select_question

email = "jill@example.com"
response = Response.new(quiz, email, "0")

quiz = Quiz.answer_question(quiz, response)

quiz = Quiz.answer_question(quiz, response)

quiz.record

quiz = Quiz.select_question(quiz)

quiz.current_question.asked

response = Response.new quiz, email, "3"

quiz = Quiz.answer_question(quiz, response)

quiz.record
