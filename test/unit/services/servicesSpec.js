describe("Unit: Testing Services", function() {

  var $httpBackend;

  beforeEach(module('luckyDashApp'));

  beforeEach(inject(function(_$httpBackend_) {
    $httpBackend = _$httpBackend_;
  }));

  it('should retrieve a customer record from the db',
    inject(function(Customer) {

    })
  );
});