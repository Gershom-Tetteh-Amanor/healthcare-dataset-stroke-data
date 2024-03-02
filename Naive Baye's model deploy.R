library(parsnip)
library(workflows)

### Creating a vetiver model
rf_spec <- naive_Bayes() %>%
  set_engine("klaR") %>%
  set_mode("classification")

rf_wf <- workflow(stroke~., rf_spec)

rf_fit <- rf_wf %>%
  fit(data=train)

### Creating a vetiver model
library(vetiver)
V <- vetiver_model(rf_fit, "`stroke prediction`")


### Storing and versioning the model
library(pins)
model_board <- board_temp(versioned = TRUE)
model_board %>% vetiver_pin_write(V)
model_board %>% pin_versions("`stroke prediction`")

### Deploying the model
library(plumber)
pr() %>%
  vetiver_api(V) %>%
  pr_run(port = 8080)
