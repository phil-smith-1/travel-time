function addPostcodeForm() {
	var div = document.getElementById("postcodes")
	var formHtml = $.ajax({ url: '/postcode-form', success: function(data) { div.insertAdjacentHTML('beforeend', data); } });
}