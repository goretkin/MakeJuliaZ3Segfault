using Z3

function add_interval_constraint(solver, var, lo, hi)
    add(solver, lo <= var)
    add(solver, var <= hi)
    return nothing
end

function answer_set(solver, solution_consts; verbose=false)
    sols = []
    while true
        res = check(solver)
        res == Z3.sat || break

        m = get_model(solver)

        # TODO not just int
        _get(const_) = get_numeral_int(Z3.eval(m, const_))

        sol = _get.(solution_consts)
        push!(sols, sol)
        verbose && (@show length(sols))

        enforce_new_solution = or((solution_consts .!= sol)...)
        add(solver, enforce_new_solution)
    end
    return sols
end

# See https://github.com/ahumenberger/Z3.jl/issues/11
Base.:+(e::Z3.ExprAllocated) = e
Base.zero(e::Z3.ExprAllocated) = Z3.int_val(ctx, 0) # TODO ctx should come from `e`, or not be used.



function sweep_arc_grid_cell(source_cell, arc_degrees)
    println("1")
    ctx = Context()
    println("2")
    # global ctx
    solver = Solver(ctx, "QF_NRA")
    println("5")
    # target cell
    x_2 = int_const(ctx, "x_2")
    y_2 = int_const(ctx, "y_2")
    cell_2 = [x_2, y_2]
    println("7")
    # a cell is a bin of values.
    dx_1 = real_const(ctx, "dx_1")
    dy_1 = real_const(ctx, "dy_1")
    d_1 = [dx_1, dy_1]

    dx_2 = real_const(ctx, "dx_2")
    dy_2 = real_const(ctx, "dy_2")
    d_2 = [dx_2, dy_2]

    # TODO maybe some of these inequalities should be strict, otherwise zero displacement of the source cell still interferes with all neighboring cells.
    for var = [dx_1, dy_1, dx_2, dy_2]
        add_interval_constraint(solver, var, -0.5, 0.5)
    end
    println("9")
    # rotation, (cosine and sine representation)
    c = real_const(ctx, "c")
    s = real_const(ctx, "s")
    println("9.5")

    R = [
        +c +s;
        -s +c
    ]
    println("9.75")
    add(solver, c^2 + s^2 == 1) # poly constraint is issue?

    # use quarter-turn symmetry, and only consider quarter turns
    println("9.755")
    add(solver, c >= 0)
    add(solver, s >= 0)

    source_point = source_cell .+ d_1
    target_point = cell_2 .+ d_2

    println("9.9")
    target_point′ = R * source_point

    add.(Ref(solver), target_point .== target_point′)

    println("10")
    sols = answer_set(solver, (x_2, y_2))
    return sols
end

sols = sweep_arc_grid_cell((10, 0), nothing)
using CartesianIndexSets: CartesianIndexSets, CartesianIndexSet

sols_grid = convert(CartesianIndexSet, Set(map(x->CartesianIndex(x...), sols)))

@show sols_grid.x
# using Plots
# Plots.heatmap(sols_grid.x.parent)

"""
julia> include("subprojects/grid_geometry_gen/src/grid_rotate_cell.jl")
1
2
5
7
9
ASSERTION VIOLATION
File: /workspace/srcdir/z3/src/ast/ast.cpp
Line: 431
UNREACHABLE CODE WAS REACHED.
4.8.8.0
Please file an issue with this message and more detail about how you encountered it at https://github.com/Z3Prover/z3/issues/new
"""
