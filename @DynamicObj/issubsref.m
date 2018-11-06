function tf=issubsref(obj,varargin)
%% Is Input a Valid Subscripted Reference of the Object?
%
% Tested on:
%  - MATLAB R2013b
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 01/04/2013
% Last modified:  09/04/2013

N=numel(varargin);
assert(N>0,...
	'MatDynObj:DynamicObj:issubsref:WrongNargin',...
	'At least one input argument is required.');
i=0;
S=obj;
while i<N
	i=i+1;
	if isprop(S,varargin{i}) || isfield(S,varargin{i})
		S=S.(varargin{i});
	else
		i=i-1;
		break
	end
end
tf=i==N;

end