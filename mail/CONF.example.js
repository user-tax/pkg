// see doc in https://nodemailer.com/smtp/
export const SMTP_FROM = "i@user.tax";
export const SMTP = {
	secure: true,
	host: "smtp.user.tax",
	port: 465,
	auth: {
		user: SMTP_FROM,
		pass: "password",
	},
	debug: false,
	logger: false,
};
