var createProduct, getProducts, program;

program = require('commander');

getProducts = function() {
  return console.log("Getting products");
};

createProduct = function() {
  return console.log("Creating product");
};

program.command('list').option('-p, --project=key', 'project key to use').description('List products');

program.command('create').option('-p, --project=key', 'project key to use').description('Create a new product');

program.parse(process.argv);

if (!program.args.length) {
  program.help();
}
