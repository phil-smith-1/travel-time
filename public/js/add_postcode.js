function addPostcodeForm() {
	var div = document.getElementById("postcodes")
	$.ajax({ url: '/postcode-form', success: function(data) { div.insertAdjacentHTML('beforeend', data); } });
}