using DelimitedFiles

Data, header = readdlm("C:/Users/nicoj/OneDrive/Desktop/MSDI/fall 2024/optimization/m4_esi6410_diet_data_full.csv", ',', header=true)

food = Data[:,1]
num = length(food)
calories = Data[:,3]
cholesterol = Data[:,4]
total_fat = Data[:,5]
sodium = Data[:,6]
carbs = Data[:,7]
fiber = Data[:,8]
protein = Data[:,9]
vit_a = Data[:,10]
vit_c = Data[:,11]
calcium = Data[:,12]
iron = Data[:,13]
price = Data[:,14]

using JuMP,GLPK

diet = Model(GLPK.Optimizer)
@variable(diet, x[1:num] >= 0)
@objective(diet,Min, sum(price[i]* x[i] for i in 1:num) )


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

optimize!(diet)
@show raw_status(diet)


println("Your diet consist of: ")
for i in 1:num
    if value(x[i])>0.0
        
        println("Food item $(food[i]) needs $(round(value(x[i]), digits = 2)) servings")
    end
end
