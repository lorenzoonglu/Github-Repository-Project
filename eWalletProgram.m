% run program %

function eWalletProgram()
 if exist('accountsData.mat', 'file')
      load('accountsData.mat', 'accounts');
 else
      accounts = struct('name', {}, 'pin', {}, 'balance', {}, 'goal', {});
 end
  while true
     fprintf('\n1. Sign In\n2. Sign Up\n3. Exit\n');
     choice = input('Enter your choice: ');

     % matching user input %
     switch choice
         case 1
             accounts = signIn(accounts);
         case 2
             accounts = signUp(accounts);
         case 3
             fprintf('Exiting...\n');
             break;
         otherwise
             fprintf('Invalid choice. Please try again.\n');
     end
 end
 save('accountsData.mat', 'accounts');
end

% sign in to existing account %
function accounts = signIn(accounts)
    accountName = input('Enter your account name: ', 's');
    pin = input('Enter your 6-digit PIN: ', 's');
    index = find(strcmp({accounts.name}, accountName));
        if ~isempty(index) && strcmp(accounts(index).pin, pin)
            fprintf('Logged in successfully.\n');
            loggedInAccount = accounts(index);
            loggedInAccount = userMenu(loggedInAccount, accounts);
            accounts(index) = loggedInAccount;
        else
            fprintf('Invalid account name or PIN.\n');
        end
end

% create account %
function accounts = signUp(accounts)
% check name %
 while true
     newAccount.name = input('Create account name: ', 's');
     if any(strcmp({accounts.name}, newAccount.name))
         fprintf('Account name already exists. Please choose a different name.\n');
     else
         break;
     end
 end
 % check pin %
 while true
     newAccount.pin = input('Create a 6-digit PIN: ', 's');
     if numel(newAccount.pin) == 6 && all(isstrprop(newAccount.pin, 'digit'))
         break;
     else
         fprintf('Invalid PIN. Please enter exactly 6 digits.\n');
     end
 end

 confirmPin = input('Confirm your 6-digit PIN: ', 's');
 % matching pin for confirmation %
 while ~strcmp(newAccount.pin, confirmPin)
     fprintf('PINs do not match. Please try again.\n');
     confirmPin = input('Confirm your 6-digit PIN: ', 's');
 end

 % initializations %
 newAccount.balance = 0;
 newAccount.goal = 0;
 accounts(end+1) = newAccount;
 fprintf('Account created successfully.\n');
end

% access functionalities of the code %
function loggedInAccount = userMenu(loggedInAccount, accounts)
 while true
     
     % checking if goal has been set and progress display %
     fprintf('\nCurrent balance: %.2f PHP\n', loggedInAccount.balance);
     if loggedInAccount.goal ~= 0
         goalProgress = loggedInAccount.balance/loggedInAccount.goal*100;
         fprintf('Current goal: %.2f PHP\n', loggedInAccount.goal);
         fprintf('Progress to goal: %.2f%%\n', goalProgress); 
         if goalProgress >= 100
            fprintf('Goal Achieved!\n');
         elseif goalProgress > 50 && goalProgress < 75
            fprintf('More than halfway there! Consider investing your money in stocks to grow your money further and faster!\n', goalProgress);
         elseif goalProgress > 75
            fprintf("We're almost there! Just a bit more.\n", goalProgress);
         end
     end    
     fprintf('\n1. Cash-in\n2. Set Goals\n3. Withdraw Money\n4. Log Out\n');
     choice = input('Enter your choice: ');
     % match user input %
     switch choice
         % cash in %
         case 1
             while true
                cashInAmount = input('Enter the amount to cash-in: ');
                % catching error %
                if cashInAmount >= 0
                    break;
                end
                fprintf('Invalid Amount. Please try again')
                % ~~~
             end
             % update balance %
             loggedInAccount.balance = loggedInAccount.balance + cashInAmount;
             fprintf('Cashed in %.2f PHP.\n', cashInAmount);
             goalStatus = loggedInAccount.goal - loggedInAccount.balance;
         % setting goal %
         case 2
             while true
                goalAmount = input('Enter the goal amount: ');
                if goalAmount > 0
                    break;
                end
                fprintf('Goal amount must be positive. Please try again.');
             end
             loggedInAccount.goal = goalAmount;
             fprintf('Goal set successfully. Current goal: %.2f PHP\n', loggedInAccount.goal);
         
         % withdrawing money %
         case 3
             withdrawAmount = input('Enter the amount to withdraw: ');
             if withdrawAmount < 0
                 fprintf('Cannot withdraw a negative amount');
             elseif withdrawAmount <= loggedInAccount.balance
                 loggedInAccount.balance = loggedInAccount.balance - withdrawAmount
             else
                 fprintf('Insufficient Balance\n')
             end
         
         % log out of account %
         case 4
             fprintf('Logging out...\n');
             return;
         otherwise
             fprintf('Invalid choice. Please try again.\n');
     end
 end
end

