function [rst] = hexer(instr)
    cp = 16;
    instr = fliplr(instr);
    len = length(instr);
    extra = mod(len, cp);
    
    rst = [];
    rst_idx = 1;
    if extra ~= 0
        rst(rst_idx) = uint16(bin2dec(instr(1:extra)));
        rst_idx = 2;
    end

    for i =  1 : len / cp
        left = (i - 1) * cp + 1 + extra;
        right = i * cp + extra;
        code = instr(left:right);
        hex = uint16(bin2dec(code));
        rst(rst_idx) = hex;
        
        rst_idx = rst_idx + 1;
    end
    
    rst = uint16(rst);
end



% function [rst] = hexer(instr)
%     cp = 32;
%     instr = fliplr(instr);
%     len = length(instr);
%     extra = mod(len, cp);
%     
%     rst = [];
%     rst_idx = 1;
%     if extra ~= 0
%         rst(rst_idx) = uint32(bin2dec(instr(1:extra)));
%         rst_idx = 2;
%     end
% 
%     for i =  1 : len / cp
%         left = (i - 1) * cp + 1 + extra;
%         right = i * cp + extra;
%         code = instr(left:right);
%         hex = uint32(bin2dec(code));
%         rst(rst_idx) = hex;
%         
%         rst_idx = rst_idx + 1;
%     end
%     
%     rst = uint32(rst);
% end
