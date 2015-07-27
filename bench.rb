
require 'open-uri' #allows grabing API's
require "rubygems" #allows grabbing GEMs
require "json" #allows reading JSON files
require "pp" #allows printing of arrays

#note: excecuting the app won't generate any results except display the total balance.
#Each requirement could have been placed in it's own method.

#Create an empty array and an empty total balance variable
@TotalBalance=0
@MasterArray=[]

#==============================================================================
#REQUIREMENT 0.0: Create a MasterArray from the 4 Jason files
#==============================================================================

#create a master array that includes all transactions from the 4 JSON pages
#note: it was found in advance and externally that there are only 4 pages
for i in 1..4 do
  url="http://resttest.bench.co/transactions/#{i}.json"

  #converts the JSON file into RUBY array
  #note: .read is equivalent to GET
  obj = JSON.parse(open(url).read)
  obj["transactions"].each do |item| #only grabs transactions HASHes
    @MasterArray.push(item)
  end
end


#==============================================================================
#REQUIREMENT 0.1: Calculates Total Balance of ALL transactions
#==============================================================================
@MasterArray.each do |item|

  #only grabs the Amounts inside each HASH
  (@TotalBalance+=item["Amount"].to_f).round(2)
end
puts "Total Balance is #{@TotalBalance}"

#==============================================================================
#REQUIREMENT #1: remove any junk
#==============================================================================
#note: only "xxx" and anything that follows was considered "junk"
@MasterArray.each do |item|
  #note: [0] simply keeps the first portion after the split
  #note: .rstrip simply removes the tailing empty space ex: "hello "
  item["Company"].split("xxx")[0].rstrip
end

#==============================================================================
#REQUIREMENT #2: Find duplicates
#==============================================================================
#note: deleting duplicates from the original array is actually straightforward
#this scans through the original array and place duplicates in a new one
#the .uniq will make sure that only 1 occurance of the duplicate exists
@DuplicateArray=@MasterArray.find_all{|item| @MasterArray.count(item) > 1}.uniq


#==============================================================================
#REQUIREMENT #3: Create List Expense Categories + Calculate total Expense
#==============================================================================

#creates a new HASH consisted solely of unique Ledger types with default values of zero
@ByCategories = Hash[@MasterArray.map {|item| [item["Ledger"], 0]}]

#reorganizes the main array by category and stores it in the new HASH, along a subtotal
@ByCategories.each do |key, value|

  #create an array for each of the unique Ledgers that will store related transactions
  @SubArray=Array.new

  #sets the intial subtotal amount to zero for each category
  @TotalExpense=0

  #run through the master array and match the Ledger with the Category in the new Hash
  @MasterArray.each do |item|
    if item["Ledger"]==key

      #transfer the transaction from the Master Array
      @ByCategories[key]=@SubArray.push(item)

      #calculate subtotal
      (@TotalExpense+=item["Amount"].to_f).round(2)
    end
  end

  #cretes a new hash consisted of the calcualted sub total and adds it to the
  #array of each Category
  @SubArray.push("Total Expense"=>@TotalExpense)
end
#pp @ByCategories


#==============================================================================
#REQUIREMENT #4: Daily caculated balances
#==============================================================================
#create an empty hash with keys for each day of the month of December
#note: it was assumed that days that didn't have transactions also needed a running balance
@ByDates=Hash.new
for i in 1..31
  @ByDates["2013-12-#{i}"]=0
end

#create an empty running balance variable
@RunningBalance=0

#calculates a running balance for each day and stores it in the new hash
@ByDates.each do |key, value|

  #run through the master array and match the Date with the Dates in the new Hash
  @MasterArray.each do |item|
    if item["Date"]==key

      #adds the amount to the running balance
      (@RunningBalance+=item["Amount"].to_f).round(2)
    end

    #sets the value of each day in the hash to be equal to the running balance
    @ByDates[key]=@RunningBalance.round(2)
  end
end

#pp @ByDates
