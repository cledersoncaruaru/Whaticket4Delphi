var Guess;
(function (Guess) {
    class Index extends IntraWeb.Code {
        constructor() {
            super(...arguments);
            this.Count = 0;
            this.Guess = NaN;
            this.Msg = '';
            this.MagicNo = Math.floor((Math.random() * 100) + 1);
        }
        WhenPageHasLoaded() {
            const xMagicNo = this.Page.WebParam('MagicNo');
            if (xMagicNo)
                this.MagicNo = parseInt(xMagicNo);
        }
        WhenGuessButtonClicked(e) {
            this.GuessEdit.Focus();
            if (e && e.shiftKey) {
                window.alert('The magic number is: ' + this.MagicNo);
                return;
            }
            this.Msg = '';
            if (isNaN(this.Guess)) {
                this.Msg = this.GuessEdit.Text.Value + ' is not a valid number.';
            }
            else if (this.Guess < 1 || this.Guess > 100) {
                this.Msg = this.Guess + ' is not in the range of 1 to 100.';
            }
            else {
                this.Count++;
                if (this.Guess < this.MagicNo) {
                    this.Msg = this.Guess + ' is too low.';
                }
                else if (this.Guess > this.MagicNo) {
                    this.Msg = this.Guess + ' is too high.';
                }
                else if (this.Guess === this.MagicNo) {
                    window.alert('Congratulations! You guessed the magic number.');
                    this.GuessButton.Enabled.Value = false;
                }
            }
            this.Guess = NaN;
        }
    }
    Guess.Index = Index;
})(Guess || (Guess = {}));
//# sourceMappingURL=Index.js.map