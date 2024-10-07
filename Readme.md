# A simple drug gathering script by Valdarix Games
Written for use with QBox and Ox Scripts. Will not add QB support.

## NOTES
	1. The script does not include Cornerselling or direct Ped selling. I use a different script to handle that.
	2. Gang or job locking is not provided in the script since I use MLOs and use ox doorlock to secure the locations based on given need.  
	3. While you can make any drug your heart desires you do need to create an item for it in Ox Inventory if it does not already exist. I currenlty use drugs already found in Ox Inventory (weed_skunk, weed_brick, meth, cokebaggy, coke_brick)


## Dependencies 
Ox-Lib
Ox-Target
Ox-Inventory

## Add the following items to your Ox Inventory Data > Items.Lua This is only needed if you are using the drugs in the default config and nor replacing them.
## Materials for processing. 
	['weed_bud'] = {
		label = "Weed Bud",
		weight = 1,
		stack = true,
		description = 'Weed bud',
		client = {
			image = 'greengelato_trimmed_bud.png',
		}
	},
	['coke_leaf'] = {
		label = "Coca Leaf",
		weight = 1,
		stack = true,
		description = 'Coca Leaf',
		client = {
			image = 'cocaleaf.png',
		}
	},
	['acetone'] = {
		label = "Acetone",
		weight = 1,
		stack = true,
		description = 'Acetone',
		client = {
			image = 'acetone.png',
		}
	},
	['ammonia'] = {
		label = "Ammonia",
		weight = 1,
		stack = true,
		description = 'Ammonia',
		client = {
			image = 'ammonia.png',
		}
	},
	['acid'] = {
		label = "Hydrocloric Acid",
		weight = 1,
		stack = true,
		description = 'Acid',
		client = {
			image = 'hydrochloricacid.png',
		}
	},
	['empty_baggie'] = {
		label = "Empty Baggie",
		weigth = 1,
		stack = true,
		description = "What can I put in here?",
		client = {
			image = 'empty-baggies.png',
		}

	},
	

## Processed Items for selling. 


You can add ass many drugs to the script as you would like in the Config File

### There is no support for this resource. Changing the notification, or drawtext to a different script is up to you.