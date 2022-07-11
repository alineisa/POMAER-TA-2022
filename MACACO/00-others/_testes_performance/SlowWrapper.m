classdef SlowWrapper < handle
  properties ( Access = public )
    A = [];
    next = 0;
  end
  methods 
    
	function this = SlowWrapper(n)
      this.A = zeros(n,1);
	end
	
    function set_next(this,a)
      this.next = this.next+1;
      this.A(this.next) = a;
	end
	
  end
end
