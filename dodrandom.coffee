jiraUsername = process.env.HUBOT_JIRA_USERNAME
jiraPass = process.env.HUBOT_JIRA_PASS
infobipUsername = process.env.HUBOT_IB_USERNAME
infobipPass = process.env.HUBOT_IB_PASS

users = {
  "denis.cutic": {
    jira: "dcutic",
  },
  josip: {
    jira: "jantolis",
  },
  mmatosevic: {
    jira: "mmatosevic",
  },
  mbruncic: {
    jira: "mbruncic",
  },
  pducic: {
    jira: "pducic",
    gsm: "385987654321"
  },
}

module.exports = (robot) ->
  robot.hear /dod (.*)/i, (response) ->
    task = response.match[1]
    possible = (user for user, value of users when user != response.message.user.name)
    lucky = possible[Math.floor(Math.random() * possible.length)]
    luckyJiraUsername = users[lucky].jira
    if jiraUsername? && jiraPass?
      jiraData = JSON.stringify({
        fields: {
          assignee: {
            name: luckyJiraUsername
          }
        }
      })
      response.http("https://jira.infobip.com/rest/api/2/issue/#{task}")
        .auth(jiraUsername, jiraPass)
        .header('Content-Type', 'application/json')
        .put(jiraData) (err, res, body) ->
          response.send(body)

    if infobipUsername? && infobipPass?
      ibData = JSON.stringify({
        to:users[lucky].gsm,
        text:"You're the lucky one: #{task}"
      })
      response.http("https://api.infobip.com/sms/1/text/single")
        .auth(infobipUsername, infobipPass)
        .header('Content-Type', 'application/json')
        .post(ibData) (err, res, body) ->
          response.send "sent SMS!"

    response.send "Hi #{response.message.user.name}! Your dod is assigned to #{lucky}. https://jira.infobip.com/browse/#{task} "
