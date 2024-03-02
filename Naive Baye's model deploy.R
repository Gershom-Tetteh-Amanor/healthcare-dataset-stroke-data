library(parsnip)
library(workflows)
#library(discrim)

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
  vetiver_api(V) %>%pr_run(port = 8080)

#library(httr)    
#set_config(use_proxy(url="10.3.100.207",port=8080))

# authenticates via environment variables:
vetiver_deploy_rsconnect(model_board,"`stroke prediction`")

vetiver_prepare_docker(model_board, "`stroke prediction`")


endpoint <- vetiver_endpoint("https://127.0.0.1:8080/predict")
endpoint



library(tibble) 
new_stroke <- tibble( gender = 'Male', 
                      age = 67, 
                      hypertension = '1', 
                      heart_disease = '1', 
                      ever_married = 'Yes', 
                      work_type = 'Private', 
                      Residence_type = 'Urban',
                      avg_glucose_level = 340, 
                      bmi = 48, 
                      smoking_status = 'smokes' )

predict(endpoint, new_stroke)
