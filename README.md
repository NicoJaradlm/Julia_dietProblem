
# Diet Optimization Model

This Julia project implements a linear optimization model to find the most cost-effective combination of food items that meets various nutritional requirements. The optimization minimizes the cost of selected food items while ensuring the diet adheres to specific nutritional constraints, such as calorie intake, fat, cholesterol, and other nutrients.

## Problem Description

The problem is a typical diet optimization scenario, where the objective is to minimize the total cost of food items while ensuring that the diet meets recommended daily intake levels for various nutrients. The input data consists of food items, each with its respective nutritional values and price. The constraints include a range of recommended intake levels for calories, cholesterol, total fat, sodium, carbohydrates, dietary fiber, protein, vitamins, calcium, and iron.

## Input Data

The data is loaded from a CSV file, `Food_data.csv`, where each row corresponds to a food item. The columns contain the following information:
- **Food**: The name of the food item.
- **Calories**: Caloric content of the food item.
- **Cholesterol**: Cholesterol content (in mg).
- **Total Fat**: Total fat content (in g).
- **Sodium**: Sodium content (in mg).
- **Carbohydrates**: Carbohydrates content (in g).
- **Fiber**: Dietary fiber content (in g).
- **Protein**: Protein content (in g).
- **Vitamin A**: Vitamin A content (in IU).
- **Vitamin C**: Vitamin C content (in mg).
- **Calcium**: Calcium content (in mg).
- **Iron**: Iron content (in mg).
- **Price**: Price per serving (in $).

## Dependencies

This project requires the following Julia packages:
- `DelimitedFiles`: For reading the CSV file.
- `JuMP`: For formulating and solving the optimization problem.
- `GLPK`: A solver used to solve the linear programming problem.

Install the necessary packages by running the following commands in the Julia REPL:

```julia
using Pkg
Pkg.add("DelimitedFiles")
Pkg.add("JuMP")
Pkg.add("GLPK")
```
# Optimization Model
The linear optimization model is built using JuMP and solved using the GLPK solver. The decision variables represent the number of servings of each food item. The objective is to minimize the total cost of the selected food items while ensuring the diet meets the following constraints:

- Total calorie intake must be between 2000 and 2250 calories.
- Cholesterol must not exceed 300 mg.
- Total fat intake must not exceed 65 g.
- Sodium intake must not exceed 2400 mg.
- Carbohydrate intake must not exceed 300 g.
- Fiber intake must be between 25 and 100 g.
- Protein intake must be between 50 and 100 g.
- Vitamin A intake must be between 5000 and 50000 IU.
- Vitamin C intake must be between 50 and 20000 mg.
- Calcium intake must be between 800 and 1600 mg.
- Iron intake must be between 10 and 30 mg.

```julia

# Load the data
Data, header = readdlm("C:/path/to/your/file/Food_data.csv", ',', header=true)

# Extract relevant columns
food = Data[:, 1]
num = length(food)
calories = Data[:, 3]
cholesterol = Data[:, 4]
total_fat = Data[:, 5]
sodium = Data[:, 6]
carbs = Data[:, 7]
fiber = Data[:, 8]
protein = Data[:, 9]
vit_a = Data[:, 10]
vit_c = Data[:, 11]
calcium = Data[:, 12]
iron = Data[:, 13]
price = Data[:, 14]

# Create the optimization model
diet = Model(GLPK.Optimizer)

# Define the decision variable: number of servings of each food item
@variable(diet, x[1:num] >= 0)

# Objective: minimize the total cost
@objective(diet, Min, sum(price[i] * x[i] for i in 1:num))

# Constraints: nutritional limits
@constraint(diet, 2000 <= sum(calories[i] * x[i] for i in 1:num) <= 2250)
@constraint(diet, 0 <= sum(cholesterol[i] * x[i] for i in 1:num) <= 300)
@constraint(diet, 0 <= sum(total_fat[i] * x[i] for i in 1:num) <= 65)
@constraint(diet, 0 <= sum(sodium[i] * x[i] for i in 1:num) <= 2400)
@constraint(diet, 0 <= sum(carbs[i] * x[i] for i in 1:num) <= 300)
@constraint(diet, 25 <= sum(fiber[i] * x[i] for i in 1:num) <= 100)
@constraint(diet, 50 <= sum(protein[i] * x[i] for i in 1:num) <= 100)
@constraint(diet, 5000 <= sum(vit_a[i] * x[i] for i in 1:num) <= 50000)
@constraint(diet, 50 <= sum(vit_c[i] * x[i] for i in 1:num) <= 20000)
@constraint(diet, 800 <= sum(calcium[i] * x[i] for i in 1:num) <= 1600)
@constraint(diet, 10 <= sum(iron[i] * x[i] for i in 1:num) <= 30)

# Solve the optimization problem
optimize!(diet)

# Display the solution
println("Your diet consists of: ")
for i in 1:num
    if value(x[i]) > 0.0
        println("Food item $(food[i]) needs $(round(value(x[i]), digits = 2)) servings")
    end
end
```
## How to Run
- Make sure the Food_data.csv file is in the correct path and contains the necessary food data.
Run the script in Julia.  

- The program will output the list of food items along with the optimal number of servings required to meet the dietary constraints at the lowest cost.
## Output
After solving the optimization problem, the script will display the list of food items and the number of servings required for each item to meet the nutritional goals.
```julia 
Your diet consists of:
Food item Apple needs 2.50 servings
Food item Milk needs 1.75 servings
```

## License
This project is open-source and available under the MIT License.

## Author
This project was created by Nicolas Jara.
