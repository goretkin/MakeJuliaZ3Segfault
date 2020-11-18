using Z3: Z3

function fun()
    println("1")
    ctx = Z3.Context()
    println("2")
    solver = Z3.Solver(ctx, "QF_NRA")
    println("3")
    c = Z3.real_const(ctx, "c")
    s = Z3.real_const(ctx, "s")
    println("4")
    R = [
        c s;
    ]
    # @show typeof(R) prevents segfault
    println("5")
    add(solver, c == 1)
    println("6")
end

sols = fun()
println("Did not segfault")

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

"""
in expression starting at /Users/goretkin/projects/z3-segfault/z3-segfault.jl:76
_ZN3api7context16reset_error_codeEv at /Users/goretkin/.julia/artifacts/71bdd8cf754f971d6fc3f9b42d2856330bb2e5b4/lib/libz3.4.8.8.0.dylib (unknown line)
Z3_get_sort at /Users/goretkin/.julia/artifacts/71bdd8cf754f971d6fc3f9b42d2856330bb2e5b4/lib/libz3.4.8.8.0.dylib (unknown line)
_ZNK2z34expr8get_sortEv at /Users/goretkin/.julia/artifacts/71bdd8cf754f971d6fc3f9b42d2856330bb2e5b4/lib/libz3jl.dylib (unknown line)
_ZNSt3__110__function6__funcIZN5jlcxx11TypeWrapperIN2z34exprEE6methodINS4_4sortES5_JEEERS6_RKNS_12basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEEEMT0_KFT_DpT1_EEUlRKS5_E_NSD_ISQ_EEFS8_SP_EEclESP_ at /Users/goretkin/.julia/artifacts/71bdd8cf754f971d6fc3f9b42d2856330bb2e5b4/lib/libz3jl.dylib (unknown line)
_ZN5jlcxx6detail17ReturnTypeAdapterIN2z34sortEJRKNS2_4exprEEEclEPKvNS_13WrappedCppPtrE at /Users/goretkin/.julia/artifacts/71bdd8cf754f971d6fc3f9b42d2856330bb2e5b4/lib/libz3jl.dylib (unknown line)
_ZN5jlcxx6detail11CallFunctorIN2z34sortEJRKNS2_4exprEEE5applyEPKvNS_13WrappedCppPtrE at /Users/goretkin/.julia/artifacts/71bdd8cf754f971d6fc3f9b42d2856330bb2e5b4/lib/libz3jl.dylib (unknown line)
get_sort at /Users/goretkin/.julia/packages/CxxWrap/94t40/src/CxxWrap.jl:590
promote at /Users/goretkin/.julia/packages/Z3/MnUlr/src/Z3.jl:71 [inlined]
"""
