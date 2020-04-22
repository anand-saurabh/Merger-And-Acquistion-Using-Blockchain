$("#button1").click(function() {
var val = $("#timeInputData").val();
mAndA.startSale(val, function(error, result){
if(error){
alert(error);
}
else
{
alert("Sale Started");
}
});
});


$("#button3").click(function() {
mAndA.closeDeal(function(error, result){
if(error){
alert(error);
}
else
{
alert("Merger and Acquistion period over. Money transferred to beneficiary");
}
});
});


//$("#button").click(function() {
//var val = $("#timeInputData").val();
//mAndA.startSale(function(val, result, error){
//if(error){
//alert(error);
//}
//else
//{
//alert("Sale Started. Negotiation Ends In Time" + result[0]);
//}
//});
//});