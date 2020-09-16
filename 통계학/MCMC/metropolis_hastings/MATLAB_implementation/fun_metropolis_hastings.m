function [accepted, rejected] = fun_metropolis_hastings(param_init, iterations, data)

x = param_init;

accepted = [];
rejected = [];

for i = 1:iterations
    x_new = fun_transition_model(x);
    x_lik = fun_log_likelihood(x, data);
    x_new_lik = fun_log_likelihood(x_new, data);
    
    if fun_acceptance(x_lik + log(fun_prior(x)), x_new_lik + log(fun_prior(x_new)))
        x = x_new;
        accepted = [accepted x_new(1)];
    else
        rejected = [rejected x_new(1)];
    end
end