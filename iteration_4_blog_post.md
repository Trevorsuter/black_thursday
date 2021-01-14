# Iteration 4 Blog Post

***For both of these methods, we created a helper method called ```find_all_items_sold_for_merchant```. This method.***

## Method find_all_items_sold_for_merchant

This method finds all the item ID’s that have been sold according to the merchant ID. The purpose of finding if an item is sold(meaning the invoice is paid in full) is because we don’t want to include anything that has not been completed and sold. We do not want to have anything that could be returned in the future because of not being able to afford the item. Furthermore, if the item isn’t purchased, it does not make much sense to include an item that does not count towards the company’s revenue. First, we created an array of invoices using the find_all_by_merchant_id method in our invoice repository, while not including any of the invoices that have not been paid in full. Next, we iterated through those id’s using a map enumerable to find all of the invoice items. This returns an array of all the invoice items for all the invoices for the merchant. Finally, we finished up by grabbing the ID’s of all the items within that array. By retrieving the item ID’s, we have the most basic form of the item, while it’s still unique to the item itself. We could use the item itself, but it would create run times to be faster if we do not use all of the information within the item itself.

## Method most_sold_items_for_merchant

For this method, we start by assigning a variable ```ids``` that equals the ```find_all_items_sold_for_merchant``` method, calling for all the item ID’s. Next, we create an empty hash with the keys being the ```uniq``` value of the ids array (which we then call on the ```find_by_id``` method in our items repository, leaving the key to be the item object rather than the ID), and the keys being the corresponding count of the item ID within the ```ids``` array. We then iterate through the hash, finding all of the keys that equal the max value of the entire hash, giving us the final output for this method.

## Method best_item_for_merchant

This method is similar to the ```most_items_sold_for_merchant method```. We first assign a variable ```ids``` that equals the ```find_all_items_sold_for_merchant``` method. Next, we create a hash which includes keys for each ```uniq``` id in the ids array, and the values being each items ```unit_price``` multiplied by the count in the array of that item. Finally, we find the key that corresponds with the max value of the hash.