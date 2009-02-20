function status = svm_learn(options, examples, model)
% SVM_LEARN - Interface to SVM light, learning module
% 
%   STATUS = SVM_LEARN(OPTIONS, EXAMPLES, MODEL)
%   Call the training program 'svm_learn' of the SVM light
%   package.
%   OPTIONS must be a structure generated by SVMLOPT.
%   EXAMPLES is the name of the file containing the training examples
%   (use SVMLWRITE to convert a Matlab matrix to the appropriate format).
%   MODEL is the name of the file holding the trained Support Vector
%   Machine.
%   If 'svm_learn' is not on the path, OPTIONS must contain a field
%   'ExecPath' with the path of the executable.
%   STATUS is the error code returned by SVM light (0 if everything went
%   fine)
%
%   See also SVMLOPT, SVMLWRITE, SVM_CLASSIFY, SVMLREAD
%

% 
% Copyright (c) by Anton Schwaighofer (2001)
% $Revision: 1.6 $ $Date: 2002/08/09 20:24:03 $
% mailto:anton.schwaighofer@gmx.net
% 
% This program is released unter the GNU General Public License.
% 

error(nargchk(3, 3, nargin));

% check parameter consistency for kernels
if ~isempty(options.Kernel),
  if (options.Kernel~=0) & isempty(options.KernelParam),
    error(sprintf('The chosen Kernel = %i requires parameters, but none are given in KernelParam', ...
                  options.Kernel));
  end
  parlen = length(options.KernelParam);
  isString = isa(options.KernelParam, 'char');
  switch options.Kernel
    case {1, 2}
      if isString | (parlen~=1),
        error(sprintf('The chosen Kernel = %i requires a scalar parameter', ...
                      options.Kernel));
      end
    case 3
       if isString | (parlen~=2),
        error(sprintf('The chosen Kernel = %i requires 2 scalar parameters', ...
                      options.Kernel));
      end
    case 4,
      if ~isString,
        error(sprintf('The chosen Kernel = %i requires a string parameter', ...
                      options.Kernel));
      end
  end
end

if ~isempty(options.NewVariables),
  if isempty(options.MaximumQP),
    maxval = 10;
  else
    maxval = options.MaximumQP;
  end
  if options.NewVariables>maxval,
    error('Option ''NewVariables'' must be smaller than 10 resp. value of MaximumQP');
  end
end

Names = fieldnames(options);
[m,n] = size(Names);

s = '';
for i = 1:m,
  field = Names{i,:};
  value = getfield(options, field);
  switch field,
    case 'Verbosity'
      s = stroption(s, '-v %i', value);
    case 'Regression'
      if ~isempty(value),
        if value==0,
          s = [s ' -z c'];
        else
          s = [s ' -z r'];
        end
      end
    case 'C'
      s = stroption(s, '-c %.10g', value);
    case 'TubeWidth'
      s = stroption(s, '-w %.10g', value);
    case 'CostFactor'
      s = stroption(s, '-j %.10g', value);
    case 'Biased'
      s = stroption(s, '-b %i', value);
    case 'RemoveIncons'
      s = stroption(s, '-i %i', value);
    case 'ComputeLOO'
      s = stroption(s, '-x %i', value);
    case 'XialphaRho'
      s = stroption(s, '-o %.10g', value);
    case 'XialphaDepth'
      s = stroption(s, '-k %.10g', value);
    case 'TransPosFrac'
      s = stroption(s, '-p %.10g', value);
    case 'Kernel'
      s = stroption(s, '-t %i', value);
    case 'KernelParam'
      if ~isempty(value),
        switch options.Kernel
          case 0
          case 1
            s = stroption(s, '-d %.10g', value(1));
          case 2
            s = stroption(s, '-g %.10g', value(1));
          case 3
            s = stroption(s, '-s %.10g -r %.10g', value(1), value(2));
          case 4
            s = stroption(s, '-u "%s"', value);
        end
      end
    case 'MaximumQP'
      s = stroption(s, '-q %i', value);
    case 'NewVariables'
      s = stroption(s, '-n %i', value);
    case 'CacheSize'
      s = stroption(s, '-m %i', value);
    case 'EpsTermin'
      s = stroption(s, '-e %.10g', value);
    case 'ShrinkIter'
      s = stroption(s, '-h %i', value);
    case 'ShrinkCheck'
      s = stroption(s, '-f %i', value);
    case 'TransLabelFile'
      s = stroption(s, '-l %s', value);
    case 'AlphaFile'
      s = stroption(s, '-a %s', value);
  end
end

evalstr = [fullfile(options.ExecPath, 'svm_learn') s ' ' ...
           examples ' ' model];
fprintf('\nCalling SVMlight:\n%s\n\n', evalstr);
if isunix,
  status = unix(evalstr);
else
  status = dos(evalstr);
end


function s = stroption(s, formatstr, value, varargin)
% STROPTION - Add a new option to string
% 

if ~isempty(value),
  s = [s ' ' sprintf(formatstr, value, varargin{:})];
end
