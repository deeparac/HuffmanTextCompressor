function [codewords, map] = dict(symbols, probs)
    plen = length(probs);
    [sorted_probs, sorted_index] = sort(probs);
    symbols = symbols(sorted_index);
    var_list = {};
    codewords = cell(1, plen);
    
    var = {};
    var.prob_list = sorted_probs;
    var.symbol_list = {};
    
    for i = 1 : plen
        var.symbol_list{i} = [i];
    end
    
    loop_var = 1;
    while (loop_var < plen)
        curr_len = length(var.prob_list);
        new_prob = var.prob_list(1) + var.prob_list(2);
        new_symbol = [var.symbol_list{1}(1:end) var.symbol_list{2}(1:end)];
        
        var_list{loop_var} = var;
        
        var.prob_list(2) = new_prob;
        var.prob_list = var.prob_list(2:end);
        [var.prob_list, idx] = sort(var.prob_list);
        
        var.symbol_list{2} = new_symbol;
        var.symbol_list = var.symbol_list(2:end);
        var.symbol_list = var.symbol_list(idx);
        
        loop_var = loop_var + 1;
    end
    
    loop_var = loop_var - 1;
    while (loop_var > 0)
        rvar = var_list{loop_var};
        rlen = length(rvar.symbol_list);
        
        rlist = rvar.symbol_list{1};
        for i = 1 : length(rlist)
            codewords{1, rlist(i)} = [codewords{1, rlist(i)}, 1];
        end
        rlist = rvar.symbol_list{2};
        for i = 1 : length(rlist)
            codewords{1, rlist(i)} = [codewords{1, rlist(i)}, 0];
        end
        
        loop_var = loop_var - 1;
    end
    
    codewords = codewords(sorted_index);
    
    map = containers.Map;
    for i = 1 : length(codewords)
        codes = num2str(cell2mat(codewords(i)));
        codes(codes == ' ') = [];
        map(codes) = symbols(i);
    end
end

