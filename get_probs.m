function f = get_probs(symbols)
	fr = histc(symbols(:), 0:255);
	total = sum(fr);
	for i = 1 : length(fr)
		f(i) = fr(i) / total;
	end
end


