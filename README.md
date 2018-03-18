The main function is located under matlab/stability_test_suite/.root_finding_cap_delaunay

To invoke the function, a handle to complex-valued function for evaluation must be provided, along with input params.

function [output_is_stable, output_zeros] = check_stability_using_delaunay_inv_for_fun(
input_function,
 USE_VERBOSE_PROFILING,
 USE_FILE_SAVE,
 USE_EARLY_QUIT)

Sample function call:
check_stability_using_delaunay_inv_for_fun(@kaczorek_eval_func, 1, 1, 0)
