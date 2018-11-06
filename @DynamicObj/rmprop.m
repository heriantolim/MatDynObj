function rmprop(obj,propName)
%% Remove Dynamic Property
%   obj.rmprop(propName) removes the property propName from obj if propName
%   exists and is a property added to the obj through the method addprop.
%
% See also: addprop.
%
% Tested on:
%  - MATLAB R2013b
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 01/04/2013
% Last modified:  09/04/2013

metaInfo=obj.findprop(propName);
if ~isempty(metaInfo)
	if isa(metaInfo,'DynamicObj')
		delete(metaInfo);
	end
end

end