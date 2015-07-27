require 'open-uri'
require "rubygems"
require "json"
require "pp"


@TotalBalance=0
@MasterArray=[]

#==============================================================================
#REQUIREMENT 0.0: Create MasterArray from 4 Jason files
#==============================================================================
for i in 1..4 do
url="http://resttest.bench.co/transactions/#{i}.json"
obj = JSON.parse(open(url).read)
  obj["transactions"].each do |item|
    #puts item["Amount"]
    #pp item
    @MasterArray.push(item)
  end
end


#==============================================================================
#REQUIREMENT 0.1: Calculates Total Balance of ALL transactions
#==============================================================================
 @MasterArray.each do |item|
   #puts @MasterArray.index(item)+1
  (@TotalBalance+=item["Amount"].to_f).round(2)
  #print element["Company"]
end
puts "Total Balance is #{@TotalBalance}"

#==============================================================================
#REQUIREMENT #1: remove any junk; specifically keeps anything before "xxx"
#==============================================================================
@MasterArray.each do |item|
    #pp item["Company"]
    pp item["Company"].split("xxx")[0].rstrip
end

#==============================================================================
#REQUIREMENT 2: Finds duplicates and places them in an array
#Deleting duplicates from an array is actually way simpler
#==============================================================================
@DuplicateArray=@MasterArray.find_all{|item| @MasterArray.count(item) > 1}.uniq


#==============================================================================
#REQUIREMENT 3: Create List Expense Categories + Calculate total Expense
#creates a new hash consisted solely of unique Ledger types with default values of zero
#==============================================================================
@ByCategories = Hash[@MasterArray.map {|item| [item["Ledger"], 0]}]

#reorganizes the main array by category and places related transactions in an array along
#a subtotal for that category
@ByCategories.each do |key, value|
  @SubArray=Array.new
  @TotalExpense=0
  @MasterArray.each do |item|
      if item["Ledger"]==key
      @ByCategories[key]=@SubArray.push(item)
      (@TotalExpense+=item["Amount"].to_f).round(2)
    end
  end
@SubArray.push("Total Expense"=>@TotalExpense)
end
#pp @ByCategories


#==============================================================================
#REQUIREMENT #4: Daily caculated balances
#create an empty hash with keys for each day of the month
#==============================================================================
@ByDates=Hash.new
for i in 1..31
  @ByDates["2013-12-#{i}"]=0
end

#calculates a running balance for each day and stores it in the hash
@RunningBalance=0
@ByDates.each do |key, value|

  @MasterArray.each do |item|
      if item["Date"]==key
      (@RunningBalance+=item["Amount"].to_f).round(2)
    end
    @ByDates[key]=@RunningBalance.round(2)
  end
end

#pp @ByDates
